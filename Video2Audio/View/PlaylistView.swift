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
    @State private var showEditor = false
    @State private var description = "faklsdjfkasdfjaskdjfkasldfjsdafs"
    private var isInPlaylists: Bool {
        playlists.contains(playlist)
    }

    var body: some View {
        List {
            ForEach($audioItems) { $audio in

                HStack {
                    Text(audio.title)
                    Spacer()
                    HStack {
                        Image(systemName: "waveform")
                        Image(systemName: "line.3.horizontal")
                    }
                    .padding(.leading)
                }
                .listRowBackground(Color.bg.opacity(0.2).blur(radius: 10))
            }
            .onMove { from, to in
                audioItems.move(fromOffsets: from, toOffset: to)
                if isInPlaylists {
                    playlist.audios = audioItems
                }
            }
            .onDelete { indices in
                for index in indices {
                    audioItems.remove(at: index)
                }
                /// setting property of playlist will cause swift data saving the playlist
                /// So if the playlist is not a saved playlist( temp playlist), don't perform the change on the playlist
                if isInPlaylists {
                    playlist.audios = audioItems
                }
            }
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top, content: {
            VStack {
                Text(playlist.title)
                    .multilineTextAlignment(.center)
                    .font(.title)

                HStack(spacing: 20) {
                    Button {
                        // TODO: play audio
                    } label: {
                        Label {
                            Text("Play")
                        } icon: {
                            Image(systemName: "play.fill")
                        }
                        .frame(maxWidth: 500, minHeight: 30)
                    }
                    .layoutPriority(1)
                    Button {
                        // TODO: change looping mode
                    } label: {
                        Label {
                            Text("Repeat")
                        } icon: {
                            Image(systemName: "repeat")
                        }
                        .frame(maxWidth: 500, minHeight: 30)
                    }
                    .layoutPriority(1)
                }
                .buttonStyle(.bordered)
                .tint(.text)
                .padding(.vertical, 4)
                Text(playlist.desc)
                    .font(.body)
                    .foregroundStyle(.text.opacity(0.8))
                    .padding(.vertical, 4)
                    .if(playlist.desc != "")
            }
            .padding(.horizontal)
        })
        .scrollContentBackground(.hidden)
        .background { AppBackground() }
        .toolbar {
            Button("Edit") {
                showEditor = true
            }
        }
        .sheet(isPresented: $showEditor, content: {
            NavigationStack {
                Form {
                    Section("Title") {
                        TextField("playlist title", text: $title)
                    }
                    Section("Description") {
                        AutoHeightTextEditor(text: $description)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showEditor = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            playlist.title = title
                            playlist.desc = description
                            showEditor = false
                        }
                    }
                }
            }
        })
        .onAppear {
            audioItems = playlist.audios
            title = playlist.title
            description = playlist.desc
        }
    }

    func savePlaylist() {
        playlist.title = title
        playlist.audios = audioItems
    }
}

#Preview {
    let playlist = Playlist(title: "example playlist", audioItems: AudioItem.sampleData.suffix(2))
    NavigationStack {
        PlaylistView(playlist: playlist)
            .modelContainer(ModelContainer.previewContainer)
    }
}
