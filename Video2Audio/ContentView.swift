//
//  ContentView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
//    @State private var tabBarHeight: CGFloat = 0
    var body: some View {
        ZStack {
            TabView {
                AudioListView()
                    .tabItem {
                        Label("Audios", systemImage: "waveform")
                    }
                    .tag(0)
                PlaylistsView()
                    .tabItem {
                        Label("Playlists", systemImage: "list.bullet")
                    }
                    .tag(1)
            }
//            .background( // Measure the TabBar height using GeometryReader
//                GeometryReader { geometry in
//                    Color.red
//                        .onAppear {
//                            // Calculate tab bar height based on safe area insets
//                            tabBarHeight = geometry.safeAreaInsets.bottom
//                        }
//                        .onChange(of: geometry.size) { _, _ in
//                            // Recalculate when size or layout changes (e.g., on rotation)
//                            tabBarHeight = geometry.safeAreaInsets.bottom
//                        }
//                }
//            )
// TODO: move playerView on top of all tabviews
//            VStack {
//                Spacer()
//
//                Text("Overlay View")
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(8)
//                    .foregroundColor(.white)
//                    .shadow(radius: 10)
//                    .safeAreaInset(edge: .bottom, spacing: 0) {
//                        Color.clear.frame(height: tabBarHeight + 16) // Adjust for tab bar height
//                    }
//            }
        }
    }
}

#Preview {
    ContentView()
}
