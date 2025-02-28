// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  NimbusCache.swift
//
//
//  Created by Vijaysubramani on 26/02/25.
//

import AVKit


@MainActor
public final class NimbusCache {

    enum LogType: String {
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }

    public static let shared = NimbusCache()
    weak var delegate: NimbusCacheEventsDelegate?

    nonisolated(unsafe) private var cacheLimitInMB: Double = 500 // Default limit for maximum cache size
    private var maxCacheAgeInDays: Double = 30 // Default days for oldest cache
    private var currentlyPlayingURL: URL?

    private init() {
        cacheLimitInMB = 500
        clearCacheIfNeeded() // Clear excess cache on initialization
        NimbusCacheEventsManager.delegate = self
    }

    // Function to set the currently playing URL
    public func setCurrentlyPlayingURL(_ url: URL) {
        currentlyPlayingURL = url
    }

    // Set cache limit dynamically
    public func setCacheLimit(_ limitInMB: Double) {
        cacheLimitInMB = limitInMB
        clearCacheIfNeeded() // Ensure cache stays within new limit
    }

    public func getCacheLimit() -> Double {
        return cacheLimitInMB
    }

    nonisolated public func getFileSizeInMB(fileSize: Double) -> Double {
        return fileSize / Double(1024 * 1024)
    }

    nonisolated private var cacheDirectoryURL: URL? {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let nimbusCacheDirectory = cachesDirectory?.appendingPathComponent("CustomCache")

        // Ensure the directory exists
        if let nimbusCacheDirectory {
            try? FileManager.default.createDirectory(at: nimbusCacheDirectory, withIntermediateDirectories: true)
        }

        return nimbusCacheDirectory
    }

    // Get the path for storing videos
    public func filePath(for url: URL) -> URL {
        return cacheDirectoryURL?.appendingPathComponent(url.lastPathComponent) ?? URL(fileURLWithPath: "")
    }

    // Public method to get the cached file URL if it exists
    public func cachedFileURL(for url: URL) -> URL? {
        let path = filePath(for: url)
        debugLog("Cached file path: ", path, logType: .info)
        return FileManager.default.fileExists(atPath: path.path) ? path : nil
    }

    // Check if the File is already cached
    public func isCached(for url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: filePath(for: url).path)
    }

    // Check if the file is being played
    public func isFileBeingPlayed(_ url: URL) -> Bool {
        return url == currentlyPlayingURL
    }

    // Get file details (URL, size, and modification date)
    private func getCachedFileDetails() -> [(url: URL, size: Int, modificationDate: Date)] {
        guard let cacheURL = cacheDirectoryURL else { return [] }
        let fileDetails = (try? FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey]))?
            .compactMap { url -> (url: URL, size: Int, modificationDate: Date)? in
                guard let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize,
                      let modificationDate = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate else { return nil }
                return (url, fileSize, modificationDate)
            } ?? []
        return fileDetails
    }

    // Get the size of stored cache in mb
    nonisolated public func calculateCacheSizeInMB() -> Double {
        guard let cacheURL = cacheDirectoryURL else { return 0.0 }
        let fileDetails = (try? FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey]))?
            .compactMap { url -> Int? in
                return try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize
            } ?? []

        let totalCacheSizeInBytes = fileDetails.reduce(0, +)
        return Double(totalCacheSizeInBytes) / (1024 * 1024) // Convert bytes to MB
    }

    // Download and save video to cache, managing memory
    public func downloadAndCacheFile(from url: URL) {
        let destinationURL = filePath(for: url)

        // Start download task
        let config = URLSessionConfiguration.background(withIdentifier: "NimbusCacheDownload")
        let session = URLSession(configuration: config)
        let task = session.downloadTask(with: url) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            guard let tempURL = tempURL, error == nil else {
                debugLog("Error downloading video:", error?.localizedDescription ?? "Unknown error", logType: .error)
                NimbusCacheEventsManager.cacheOperationFailure(url: url.description, errorMessage: "Error downloading video: \(error?.localizedDescription ?? "Unknown error") ", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))
                return
            }

            do {
                // Move downloaded file to cache directory
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                debugLog("Video downloaded and saved to cache:", destinationURL, logType: .info)
                let cachedTimeStampKey = try? destinationURL.resourceValues(forKeys: [.contentModificationDateKey])
                let cachedTimeStamp = cachedTimeStampKey?.contentModificationDate
                NimbusCacheEventsManager.cacheSuccess(url: url.absoluteString, fileSizeInMB: getFileSizeInMB(fileSize: Double(response?.expectedContentLength ?? 0)), totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB), cachedTimeStamp: NimbusCommonUtil.getFormattedDateWithTime(dateValue: cachedTimeStamp))

                Task {
                    await self.clearCacheIfNeeded() // Manage cache size after new file addition
                }
            } catch {
                debugLog("Error saving video:", error.localizedDescription, logType: .error)
                NimbusCacheEventsManager.cacheFailure(url: url.description, errorMessage: error.localizedDescription, totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))
            }
        }

        task.resume()
    }

    // Clear old cache based on the modification date.
    private func clearOldCacheFiles() {

        // Step 1: Calculate expiration date based on maxCacheAgeInDays
        let expirationDate = Date().addingTimeInterval(-.days(maxCacheAgeInDays))

        // Step 2: Get file details (URL, size, and modification date)
        let cachedFiles = getCachedFileDetails()

        // Step 3: Sort files by modification date (oldest first)
        let sortedFiles = cachedFiles.sorted { $0.modificationDate < $1.modificationDate }
        // Delete files only if the file is older than expiration date
        for cachedFile in sortedFiles where cachedFile.modificationDate < expirationDate {
            do {
                try FileManager.default.removeItem(at: cachedFile.url)
                debugLog("Old Cache deleted: \(cachedFile.url)", logType: .info)

                NimbusCacheEventsManager.cacheCleared(url: cachedFile.url.description, totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB), fileSizeInMB: getFileSizeInMB(fileSize: Double(cachedFile.size)), cachedTimeStamp: NimbusCommonUtil.getFormattedDateWithTime(dateValue: cachedFile.modificationDate), maxCacheAgeInDays: maxCacheAgeInDays, isOldCache: true)

            } catch {
                debugLog("Failed to delete cached video at \(cachedFile.url): \(error.localizedDescription)", logType: .error)
                NimbusCacheEventsManager.cacheOperationFailure(url: cachedFile.url.description, errorMessage: "Failed to delete cached video at \(cachedFile.url.description): \(error.localizedDescription)", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))
            }
        }
    }

    // Cache clearing function with database checks
    private func clearCacheIfNeeded() {
        // Step 1: Get file details (URL, size, and modification date)
        let fileDetails = getCachedFileDetails()

        debugLog("Cached file details: \n", fileDetails, logType: .info)

        // Step 2: Calculate total cache size
        var totalCacheSize: Double = Double(fileDetails.reduce(0) { $0 + $1.size })
        let limitInBytes = cacheLimitInMB * 1024 * 1024

        // Step 3: If total cache size exceeds limit, start deleting files
        if totalCacheSize > limitInBytes {

            NimbusCacheEventsManager.cacheLimitExceeded(totalCacheSizeInMB: Double(calculateCacheSizeInMB()), cacheLimitInMB: Double(cacheLimitInMB))

            // Sort files by modification date (oldest first)
            let sortedFiles = fileDetails.sorted { $0.modificationDate < $1.modificationDate }

            // Step 4: Delete files until total cache size is within limit
            for file in sortedFiles {
                guard totalCacheSize > limitInBytes else { break }

                // Skip deleting the video file if it is currently being played
                if isFileBeingPlayed(file.url) {
                    debugLog("Skipping deletion of currently playing video: \(file.url)", logType: .warning)
                    NimbusCacheEventsManager.cacheOperationFailure(url: file.url.description, errorMessage: "Skipping deletion of currently playing video: \(file.url.description)", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))

                    continue
                }

                do {
                    try FileManager.default.removeItem(at: file.url)
                    totalCacheSize -= Double(file.size)
                    debugLog("Cache deleted due to exceeded cache limit: \(file.url)", logType: .info)

                    NimbusCacheEventsManager.cacheCleared(url: file.url.description, totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB), fileSizeInMB: getFileSizeInMB(fileSize: Double(file.size)), cachedTimeStamp: NimbusCommonUtil.getFormattedDateWithTime(dateValue: file.modificationDate), maxCacheAgeInDays: maxCacheAgeInDays, isOldCache: false)

                } catch {
                    debugLog("Failed to delete cached video at \(file.url): \(error.localizedDescription)", logType: .error)
                    NimbusCacheEventsManager.cacheOperationFailure(url: file.url.description, errorMessage: "Failed to delete cached video at \(file.url.description): \(error.localizedDescription)", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))
                }
            }
        } else {
            clearOldCacheFiles()
        }
    }

    // Clear all cached videos
    public func clearAllCache() {
        guard let cacheURL = cacheDirectoryURL else { return }

        let fileURLs = (try? FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil)) ?? []

        for fileURL in fileURLs {
            // Skip deleting the video file if it is currently being played
            if isFileBeingPlayed(fileURL) {
                debugLog("Skipping deletion of currently playing video: \(fileURL)", logType: .warning)
                NimbusCacheEventsManager.cacheOperationFailure(url: fileURL.description, errorMessage: "Skipping deletion of currently playing video: \(fileURL.description)", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))

                continue
            }

            do {
                try FileManager.default.removeItem(at: fileURL)
                debugLog("Cache deleted at", fileURL, logType: .info)
                NimbusCacheEventsManager.clearAllCache(totalCacheSizeInMB: Double(calculateCacheSizeInMB()), cacheLimitInMB: Double(cacheLimitInMB))
            } catch {
                debugLog("Failed to delete cached video at \(fileURL): \(error.localizedDescription)", logType: .error)

                NimbusCacheEventsManager.cacheOperationFailure(url: fileURL.description, errorMessage: "Failed to delete cached video at \(fileURL): \(error.localizedDescription)", totalCacheSizeInMB: calculateCacheSizeInMB(), cacheLimitInMB: Double(cacheLimitInMB))
            }
        }
    }

    nonisolated fileprivate func debugLog(_ items: Any..., separator: String = " ", terminator: String = "\n", logType: LogType) {
#if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("[NimbusCache]: [\(logType.rawValue)] ", output, terminator: terminator)
#endif
    }

}

extension NimbusCache: @preconcurrency NimbusCacheEventsDelegate {
    public func numbusCacheRecordEvents(eventName: String, properties: [String : Any]) {
        delegate?.numbusCacheRecordEvents(eventName: eventName, properties: properties)
    }
}

extension AVPlayerItem {
    convenience init?(url: URL, isCacheEnabled: Bool = false, cacheManager: NimbusCache = NimbusCache.shared) {

        guard isCacheEnabled else {
            self.init(asset: AVAsset(url: url))
            cacheManager.debugLog("Caching disabled", logType: .info)
            NimbusCacheEventsManager.cachingDisabled()
            return
        }

        // Use cached video if available, otherwise download and cache
        if let cachedURL = cacheManager.cachedFileURL(for: url) {
            cacheManager.debugLog("Playing cached video from: \(cachedURL)", logType: .info)
            self.init(asset: AVAsset(url: cachedURL))
            cacheManager.setCurrentlyPlayingURL(cachedURL)
            let fileSize = try? cachedURL.resourceValues(forKeys: [.fileSizeKey]).fileSize
            NimbusCacheEventsManager.videoPlaybackFromCache(url: url.description, fileSizeInMB: cacheManager.getFileSizeInMB(fileSize: Double(fileSize ?? 0)), totalCacheSizeInMB: cacheManager.calculateCacheSizeInMB(), cacheLimitInMB: (Double(cacheManager.getCacheLimit())))
        } else {
            cacheManager.debugLog("Downloading and caching video", logType: .info)
            self.init(asset: AVAsset(url: url))
            NimbusCacheEventsManager.cachingInitiated(url: url.description, totalCacheSizeInMB: cacheManager.calculateCacheSizeInMB(), cacheLimitInMB: (Double(cacheManager.getCacheLimit())))
            cacheManager.downloadAndCacheFile(from: url)
        }
    }
}

extension TimeInterval {
    static func days(_ days: Double) -> TimeInterval {
        return days * 86_400 // 86,400 seconds in a day
    }
}

