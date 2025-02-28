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
    func testSetCacheLimit() {
        let cacheLimit = 250.0
        #expect(cacheManager != nil)
        cacheManager?.setCacheLimit(cacheLimit)
        #expect(cacheManager?.getCacheLimit() == cacheLimit)
    }

    //TODO: Need to cover tests for all the functions.

}
