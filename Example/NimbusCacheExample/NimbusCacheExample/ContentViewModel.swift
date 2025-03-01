//
//  ContentViewModel.swift
//  NimbusCacheExample
//
//  Created by Vijaysubramani on 28/02/25.
//

import SwiftUI
import NimbusCache

@MainActor
class ContentViewModel: ObservableObject, @preconcurrency NimbusCacheEventsDelegate {

    let cacheManager = NimbusCache.shared

    let videoUrls: [URL] = [URL(string: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")!, URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")!]

    init() {
        cacheManager.delegate = self
    }

    func nimbusCacheRecordEvents(eventName: String, properties: [String : Any]) {
        print("event Name: \(eventName), properties: \(properties)")
    }

    func clearAllCache() {
        cacheManager.clearAllCache()
    }

    func setCacheLimit(limit: Double) {
        cacheManager.setCacheLimit(limit)
    }

    func getVideoUrl() -> URL {
        return videoUrls.randomElement()!
    }

}
