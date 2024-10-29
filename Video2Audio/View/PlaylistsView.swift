//
//  PlayListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/19.
//

import SwiftData
import SwiftUI
struct PlaylistsView: View {
    @Query private var playlists: [Playlist]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode

    @State private var currentPlayingAudio: AudioItem?
    @State private var currentPlaylist: Playlist?

    var body: some View {
        List {
            ForEach(playlists) { playlist in
                Button {
                    currentPlaylist = playlist
                } label: {
                    Label {
                        Text(playlist.title)
                    } icon: {
                        Image(systemName: "list.bullet")
                    }
                }
                .foregroundStyle(Color.text)
                .listRowBackground(Color.bg)
            }
            .onDelete { indices in
                for index in indices {
                    let playlistToDelete = playlists[index]
                    if playlistToDelete == currentPlaylist {
                        currentPlaylist = nil
                    }
                    modelContext.delete(playlists[index])
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            AppBackground()
        }
        .safeAreaInset(edge: .bottom, content: {
            if let currentPlaylist {
                AudioPlayerView(playlist: currentPlaylist, currentPlayingAudio: $currentPlayingAudio)
            }
        })
        .navigationTitle("Playlists")
    }
}

#Preview {
    PlaylistsView()
        .modelContainer(ModelContainer.previewContainer)
}
