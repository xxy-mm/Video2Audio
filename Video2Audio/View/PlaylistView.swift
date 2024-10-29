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

    @State private var audioItems = [AudioItem]()
    @State private var title: String = "Untitled Playlist"
    @State private var editManager = EditModeManager()

    private var isInPlaylists: Bool {
        playlists.contains(playlist)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach($audioItems) { $audio in

                    HStack {
                        Text(audio.title)
                        Spacer()
                        //                    Image(systemName: "waveform")
                        //                        .if(isPlaying(audio: audio))
                    }
                }
                .onMove { from, to in
                    audioItems.move(fromOffsets: from, toOffset: to)
                    if isInPlaylists {
                        playlist.audioItems = audioItems
                    }
                }
                .onDelete { indices in
                    for index in indices {
                        audioItems.remove(at: index)
                    }
                    /// setting property of playlist will cause swift data saving the playlist
                    /// So if the playlist is not a saved playlist( temp playlist), don't perform the change on the playlist
                    if isInPlaylists {
                        playlist.audioItems = audioItems
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
                ToolbarItem(placement: .principal) {
                    if editManager.isEditing {
                        TextField("title", text: $title)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .onSubmit {
                                /// if a user changes the title of the temp list
                                /// typically means the user want to save the list
                                /// so save the temp list
                                savePlaylist()
                                editManager.done()
                            }

                    } else {
                        Text(playlist.title)
                            .font(.title2)
                            .onTapGesture {
                                editManager.edit()
                            }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    EditButton()
                }
            }
            .printChange(of: playlist.audioItems)

            .onAppear {
                audioItems = playlist.audioItems
                title = playlist.title
            }
        }
    }
    
    func savePlaylist() {
        playlist.title = title
        playlist.audioItems = audioItems
    }
}

#Preview {
    let playlist = Playlist(title: "example playlist", audioItems: AudioItem.sampleData.suffix(2))
    PlaylistView(playlist: playlist)
        .modelContainer(ModelContainer.previewContainer)
}
