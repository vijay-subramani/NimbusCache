import Testing
import Foundation
@testable import NimbusCache

@MainActor
@Suite class NimbusCacheTests {
    var cacheManager: NimbusCache?
    let testMediaUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

    init() {
        self.cacheManager = NimbusCache.shared
    }

    @Test("Set Currently Playing URL")
    func testSetCurrentlyPlayingURL() {
        #expect(testMediaUrl != nil)
        #expect(cacheManager != nil)
        if let testMediaUrl {
            cacheManager?.setCurrentlyPlayingURL(testMediaUrl)
            let isFileBeingPlayed = cacheManager?.isFileBeingPlayed(testMediaUrl)
            #expect(isFileBeingPlayed == true)
        } else {
            Issue.record("Unexpected Error")
        }
    }

    @Test("Set Cache limit")
    func testSetCacheLimit() async {
        let cacheLimit = 250.0
        #expect(cacheManager != nil)
        cacheManager?.setCacheLimit(cacheLimit)
        // Wait briefly to ensure async update completes
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        #expect(cacheManager?.getCacheLimit() == cacheLimit)

    }

    @Test("Check if 2 urls having same name as last path component, it will save seperately or not")
    func testSameNameDifferentURL() {
        let firstUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        let secondUrl = URL(string:"http://googleapis.com/gtv-videos/sample/BigBuckBunny.mp4")

        //These are 2 seperate test urls having same last path component as "BigBuckBunny.mp4". This should have different paths in the cache. So that we can avoid missing any urls having same name in the last path component.
        #expect(firstUrl != nil)
        #expect(secondUrl != nil)
        let firstUrlFilePath = cacheManager?.filePath(for: firstUrl!)
        let secondUrlFilePath = cacheManager?.filePath(for: secondUrl!)
        #expect(firstUrlFilePath != secondUrlFilePath)
    }

    //TODO: Need to cover tests for all the functions.

}
