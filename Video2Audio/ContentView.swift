//
//  ContentView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var tabBarHeight: CGFloat = 0
    
    @State private var currentPlayingAudio: AudioItem?
    var body: some View {
        ZStack {
            HomeGridView()

            .background( // Measure the TabBar height using GeometryReader
                GeometryReader { geometry in
                    Color.red
                        .onAppear {
                            // Calculate tab bar height based on safe area insets
                            tabBarHeight = geometry.safeAreaInsets.bottom
                        }
                        .onChange(of: geometry.size) { _, _ in
                            // Recalculate when size or layout changes (e.g., on rotation)
                            tabBarHeight = geometry.safeAreaInsets.bottom
                        }
                }
            )
             
            VStack {
                Spacer()

                AudioPlayerView(currentPlayingAudio: $currentPlayingAudio)
            }
        }
    }
}

#Preview {
    ContentView()
}
