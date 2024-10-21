//
//  PlaylistDetailView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/19.
//

import SwiftData
import SwiftUI

struct PlaylistView: View {
    var playlist: Playlist
    @Query private var playlists: [Playlist]
    @Environment(\.modelContext) private var modelContext
    
    private var isInPlaylists: Bool {
        playlists.contains(playlist)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(playlist.audioItems) { audio in

                    HStack {
                        Text(audio.title)
                        Spacer()
                        //                    Image(systemName: "waveform")
                        //                        .if(isPlaying(audio: audio))
                    }
                }
                .onMove { from, to in
                    playlist.audioItems.move(fromOffsets: from, toOffset: to)
                }
                .onDelete { indices in
                    for index in indices {
                        playlist.audioItems.remove(at: index)
                    }
                }
            }
            .listStyle(.plain)
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isInPlaylists ? modelContext.delete(playlist) : modelContext.insert(playlist)

                    } label: {
                        Image(systemName: isInPlaylists ? "star.fill" : "star")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    EditButton()
                }
            }
            .onChange(of: playlist.audioItems) { oldValue, newValue in
                print("old ids \(oldValue)")
                print("new ids \(newValue)")
            }
        }
    }
}

#Preview {
    ModelContainerPreview {
        try! ModelContainer.sample()
    } content: {
        PlaylistView(playlist: Playlist.sampleData[0])
    }
}
