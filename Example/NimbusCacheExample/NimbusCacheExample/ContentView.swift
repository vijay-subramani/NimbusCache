//
//  ContentView.swift
//  NimbusCacheExample
//
//  Created by Vijaysubramani on 28/02/25.
//

import SwiftUI
import NimbusCache

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    NavigationLink("Play Video") {
                        VideoPlayerView(videoUrl: viewModel.getVideoUrl())
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer()
            Button("Clear All Cache") {
                viewModel.clearAllCache()
            }
            Button("Set cache limit") {
                viewModel.setCacheLimit(limit: 200)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
