//
//  HomeListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/31.
//

import SwiftData
import SwiftUI

/// This view is used for ipad and macos
struct HomeListView: View {
    @Query private var audiosItems: [AudioItem]
    @Query private var Playlists: [Playlist]
    @Query private var tasks: [ConvertionTask]

    @State private var selection: GridLink?
    @State private var currentPlayingAudio: AudioItem?
    private var favorites: [AudioItem] {
        audiosItems.filter { $0.isFavorite ?? false }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: GridLink.audios) {
                    Label {
                        Text("All audios")
                    } icon: {
                        Image(systemName: "arrow.down.circle")
                    }
                }

                NavigationLink(value: GridLink.tasks) {
                    Label {
                        Text("Tasks")
                    } icon: {
                        Image(systemName: "plus.circle")
                    }
                }
                NavigationLink(value: GridLink.favorites) {
                    Label {
                        Text("Favorites")
                    } icon: {
                        Image(systemName: "heart")
                    }
                }
                NavigationLink(value: GridLink.playlists) {
                    Label {
                        Text("Playlists")
                    } icon: {
                        Image(systemName: "music.note.list")
                    }
                }
            }
            .navigationTitle("Home")
            .scrollContentBackground(.hidden)
            .background {
                AppBackground()
                    .blur(radius: 10)
            }
        } detail: {
            ZStack {
                if let selection {
                    switch selection {
                    case .favorites:
                        FavoriteAudioList()
                    case .playlists:
                        PlaylistsView()
                    case .audios:
                        AudioListView()
                    case .tasks:
                        TaskListView()
                    }
                    VStack {
                        Spacer()
                        AudioPlayerView(currentPlayingAudio: $currentPlayingAudio)
                    }
                } else {
                    AppBackground()
                }
            }
        }
    }
}

#Preview {
    HomeListView()
        .modelContainer(ModelContainer.previewContainer)
}
