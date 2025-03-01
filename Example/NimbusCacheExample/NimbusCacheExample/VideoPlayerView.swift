//
//  VideoPlayerView.swift
//  NimbusCacheExample
//
//  Created by Vijaysubramani on 28/02/25.
//


import SwiftUI
import AVKit
import NimbusCache

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var error: Error?

    func loadAsset(from url: URL) {
        let asset = AVURLAsset(url: url)

        // Load the asset asynchronously
//        asset.load(.tracks) { [weak self] in
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self] in
            guard let self = self else { return }

            var error: NSError?
//            let status = asset.status(of: .tracks)
            let status = asset.statusOfValue(forKey: "tracks", error: &error)

            DispatchQueue.main.async {
                switch status {
                case .loaded:
                    // Asset is loaded, create the player item and player
                    let playerItem = AVPlayerItem(asset: asset)
                    self.player = AVPlayer(playerItem: playerItem)

                case .failed:
                    self.error = error
                    print("Asset loading failed: \(error?.localizedDescription ?? "Unknown error")")

                case .cancelled:
                    print("Asset loading was cancelled")

                default:
                    break
                }
            }
        }
    }
}

struct VideoPlayerView: View {
    @State private var player = AVPlayer()
    @StateObject private var viewModel = VideoPlayerViewModel()
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
