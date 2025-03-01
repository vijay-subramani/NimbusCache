//
//  VideoPlayerView.swift
//  NimbusCacheExample
//
//  Created by Vijaysubramani on 28/02/25.
//


import SwiftUI
import AVKit
import NimbusCache

struct VideoPlayerView: View {
    @State private var player = AVPlayer()
    var videoUrl: URL?

    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task {
                    if let videoUrl, let playerItem = await AVPlayerItem(url: videoUrl, isCacheEnabled: true) {
                        player = AVPlayer(playerItem: playerItem)
                        player.play()
                    }
                }
            }
            .onDisappear {
                player.pause()
            }
    }
}

#Preview {
    VideoPlayerView(videoUrl: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
}
