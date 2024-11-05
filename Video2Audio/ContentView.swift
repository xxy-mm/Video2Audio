//
//  ContentView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var audioItems: [AudioItem]
    @Query private var playlists: [Playlist]
    @Query private var tasks: [ConvertionTask]
    
    @State private var selection = 0
    @State private var tabBarHeight: CGFloat = 0
    @State private var audioPlayer = AudioPlayer()

  
    @State private var showExpandedPlaylist = false
    var body: some View {
        ZStack {
            HomeListView()
                .safeAreaInset(edge: .bottom) {
                    Color.clear
                        .frame(height: 50)
                }
            
        }
        .environment(audioPlayer)
    }
}

#Preview {
    ContentView()
        .environment(AudioPlayer(audioItems: AudioItem.sampleData))
}
