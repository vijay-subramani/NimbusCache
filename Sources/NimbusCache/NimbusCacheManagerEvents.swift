//
//  NimbusCacheManagerEvents.swift
//  
//
//  Created by Vijaysubramani on 26/02/25.
//

import Foundation

public protocol NimbusCacheEventsDelegate: AnyObject {
    func numbusCacheRecordEvents(eventName: String, properties: [String: Any])
}

class NimbusCacheEventsManager {

    nonisolated(unsafe) weak static var delegate: NimbusCacheEventsDelegate?

    static func cachingDisabled() {
        triggerEvent(eventName: NimbusCacheEvents.kNCM_CachingDisabled, properties: [:])
    }

    static func cachingInitiated(url: String, totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        triggerEvent(eventName: NimbusCacheEvents.kNCM_CachingInitiated, properties: segmentDict)
    }

    static func cacheSuccess(url: String, fileSizeInMB: Double, totalCacheSizeInMB: Double, cacheLimitInMB: Double, cachedTimeStamp: String) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kFileSizeInMB.rawValue] = fileSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCachedTimeStamp.rawValue] = cachedTimeStamp

        triggerEvent(eventName: NimbusCacheEvents.kNCM_CacheSuccess, properties: segmentDict)
    }

    static func cacheFailure(url: String, errorMessage: String, totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kCacheErrorMessage.rawValue] = errorMessage
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        triggerEvent(eventName: NimbusCacheEvents.kNCM_CacheFailure, properties: segmentDict)
    }

    static func videoPlaybackFromCache(url: String, fileSizeInMB: Double, totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kFileSizeInMB.rawValue] = fileSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        triggerEvent(eventName: NimbusCacheEvents.kNCM_VideoPlaybackFromCache, properties: segmentDict)
    }

    static func cacheCleared(url: String, totalCacheSizeInMB: Double, cacheLimitInMB: Double, fileSizeInMB: Double, cachedTimeStamp: String, maxCacheAgeInDays: Double, isOldCache: Bool) {

        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kFileSizeInMB.rawValue] = fileSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCachedTimeStamp.rawValue] = cachedTimeStamp
        segmentDict[NimbusCacheEvents.Properties.kCacheExpiryTimeInDays.rawValue] = maxCacheAgeInDays
        segmentDict[NimbusCacheEvents.Properties.kIsOldCache.rawValue] = isOldCache
        triggerEvent(eventName: NimbusCacheEvents.kNCM_CacheCleared, properties: segmentDict)
    }

    static func cacheOperationFailure(url: String, errorMessage: String, totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kUrl.rawValue] = url
        segmentDict[NimbusCacheEvents.Properties.kCacheErrorMessage.rawValue] = errorMessage
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        triggerEvent(eventName: NimbusCacheEvents.kNCM_CacheOperationFailure, properties: segmentDict)
    }

    static func cacheLimitExceeded(totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)

        triggerEvent(eventName: NimbusCacheEvents.kNCM_CacheLimitExceeded, properties: segmentDict)
    }

    static func clearAllCache(totalCacheSizeInMB: Double, cacheLimitInMB: Double) {
        var segmentDict = [String: Any]()
        segmentDict[NimbusCacheEvents.Properties.kTotalCacheSizeInMB.rawValue] = totalCacheSizeInMB.roundedValues(toPlaces: 2)
        segmentDict[NimbusCacheEvents.Properties.kCacheLimitInMB.rawValue] = cacheLimitInMB.roundedValues(toPlaces: 2)
        triggerEvent(eventName: NimbusCacheEvents.kNCM_AllCacheCleared, properties: segmentDict)
    }

    nonisolated static func triggerEvent(eventName: String, properties: [String: Any]) {
        var segmentDict = [String: Any]()
        if !properties.isEmpty {
            segmentDict.merge(properties) { (event, _) in event }
        }
        delegate?.numbusCacheRecordEvents(eventName: eventName, properties: segmentDict)
    }
}

public struct NimbusCacheEvents {
    static let kNCM_CachingDisabled = "NCM_CachingDisabled"
    static let kNCM_CachingInitiated = "NCM_CachingInitiated"
    static let kNCM_CacheSuccess = "NCM_CacheSuccess"
    static let kNCM_CacheFailure = "NCM_CacheFailure"
    static let kNCM_CacheLimitExceeded = "NCM_CacheLimitExceeded"
    static let kNCM_CacheCleared = "NCM_CacheCleared"
    static let kNCM_AllCacheCleared = "NCM_AllCacheCleared"
    static let kNCM_VideoPlaybackFromCache = "NCM_VideoPlaybackFromCache"
    static let kNCM_CacheOperationFailure = "NCM_CacheOperationFailure"

    enum Properties: String {
        case kUrl = "NCM_Url"
        case kFileSizeInMB = "NCM_FileSizeInMB"
        case kTotalCacheSizeInMB = "NCM_TotalCacheSizeInMB"
        case kCacheLimitInMB = "NCM_CacheLimitInMB"
        case kCachedTimeStamp = "NCM_CachedTimeStamp"
        case kCacheErrorMessage = "NCM_CacheErrorMessage"
        case kCacheExpiryTimeInDays = "NCM_CacheExpiryTimeInDays"
        case kIsOldCache = "NCM_IsOldCache"
    }
}
