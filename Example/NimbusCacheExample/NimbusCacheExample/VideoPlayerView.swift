import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var player = AVPlayer()
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
            .onAppear {
                let url = URL(string: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")!
                
                player = AVPlayer(url: url)
                player.play()
                
            }
            .onDisappear {
                player.pause()
            }
    }
}

#Preview {
    VideoPlayerView()
}