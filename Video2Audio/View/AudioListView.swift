//
//  AudioListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import AVFoundation
import SwiftData
import SwiftUI

struct AudioListView: View {
    /// swift data
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AudioItem.title) private var audios: [AudioItem]
    /// file importer
    @State private var showVideoPicker = false
    /// audio player
    @State private var currentPlayingAudio: AudioItem?
    @State private var showPlayerView = false
    @State private var playList: Playlist?

    /// edit mode
    @State private var selectedAudios = [AudioItem]()
    @State private var editMode: EditMode = .inactive
    @State private var hasSelectAll = false
    /// file exporter
    @State private var audiosToExport = Set<AudioItem>()
    @State private var showExporter = false

    /// alert
    @State private var showAlert = false
    @State private var message = ""

    let title = "Audios"
    let playingIndicatorIcon = "waveform"
    let trashIcon = "trash"
    let exportIcon = "square.and.arrow.up"
    let selectAllText = "Select All"
    let deselectAllText = "Deselect All"
    let importIcon = "plus"
    let editButtonText = "Edit"
    let editButtonDoneText = "Done"

    var body: some View {
        NavigationStack {
            List {
                if !audios.isEmpty {
                    ForEach(audios) { audio in
                        HStack {
                            if editMode == .active {
                                SelectRadio(collection: $selectedAudios, current: audio)
                            }
                            playButton(audio)
                            Spacer()
                            Image(systemName: playingIndicatorIcon)
                                .if(!isPlaying(audio: audio)) { view in
                                    view.hidden()
                                }
                            audio.icon
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteAudio(audio)
                            } label: {
                                Image(systemName: trashIcon)
                            }

                            Button {
                                audiosToExport.insert(audio)
                                showExporter = true
                            } label: {
                                Image(systemName: exportIcon)
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom, content: {
                VStack {
                    AudioPlayerView(playlist: playList, currentPlayingAudio: $currentPlayingAudio)
                        .if(showPlayerView && editMode == .inactive)
                }
                .padding(.bottom)

            })
            .safeAreaInset(edge: .bottom, content: {
                BatchActionBar {
                    audiosToExport = Set(selectedAudios)
                    resetSelection()
                } onPlay: {
                    updatePlayList(selectedAudios)
                    resetSelection()
                } onDelete: {
                    for audio in selectedAudios {
                        deleteAudio(audio)
                    }
                    resetSelection()
                }.if(editMode == .active)
            })
            .toolbar {
                if editMode == .active {
                    selectAllButton()
                }
                editButton()
                importButton()
            }
            .navigationTitle(title)
            .fileImporter(isPresented: $showVideoPicker, allowedContentTypes: [.mpeg, .mpeg2Video, .mpeg4Movie, .quickTimeMovie], allowsMultipleSelection: true, onCompletion: convertVideos)
            .fileExporter(isPresented: $showExporter, documents: audiosToExport.map { AudioFile(url: $0.url) }, contentType: .mpeg4Audio) { result in
                do {
                    _ = try result.get()
                    audiosToExport.removeAll()
                } catch {
                    // TODO: record error
                    showAlert = true
                    message = error.localizedDescription
                }
            }
            .alert("export status", isPresented: $showAlert) {
            } message: {
                Text(message)
            }
        }
    }

    func resetSelection() {
        editMode = .inactive
        selectedAudios.removeAll()
        hasSelectAll = false
    }

    // MARK: - views

    func playButton(_ audio: AudioItem) -> some View {
        Button {
            if editMode == .inactive,
               audio.status == .success {
                updatePlayList([audio])
            }
        } label: {
            Text(audio.title)
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }

    func importButton() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                showVideoPicker = true
            } label: {
                Image(systemName: importIcon)
            }
        }
    }

    func selectAllButton() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(hasSelectAll ? deselectAllText : selectAllText) {
                hasSelectAll ? selectedAudios.removeAll() : selectedAudios.append(contentsOf: audios)
                withAnimation {
                    hasSelectAll.toggle()
                }
            }
        }
    }

    func editButton() -> some ToolbarContent {
        ToolbarItem {
            Button {
                if editMode == .active {
                    withAnimation {
                        editMode = .inactive
                    }
                } else {
                    withAnimation {
                        editMode = .active
                    }
                }
            } label: {
                Text(editMode == .inactive ? editButtonText : editButtonDoneText)
            }
        }
    }

    // MARK: - functions

    func updatePlayList(_ audios: [AudioItem]) {
        guard !audios.isEmpty else { return }
        let _playlist = Playlist(title: "Untitled playlist", audioItems: audios)
        playList = _playlist
        showPlayerView = true
    }

    func convertVideos(_ result: Result<[URL], any Error>) {
        do {
            let urls = try result.get()

            for url in urls {
                Task {
                    let gotAccess = url.startAccessingSecurityScopedResource()
                    if !gotAccess {
                        print("Failed to access security video files")
                        return
                    }
                    let audioURL = VideoConverter.getAudioURL(from: url)
                    let item = AudioItem(videoURL: url, audioURL: audioURL)
                    modelContext.insert(item)
                    if await VideoConverter.convertVideoToAudio(video: item.sourceURL, audio: item.url) {
                        item.status = .success
                    } else {
                        item.status = .error
                    }
                    url.stopAccessingSecurityScopedResource()
                }
            }
        } catch {
            print("Failed to convert: \(error.localizedDescription)")
        }
    }

    func deleteAudio(_ audio: AudioItem) {
        // TODO: also delete the file
        // TODO: if the audio is playing, we need to do some extra work before deleting
        modelContext.delete(audio)
    }

    func isPlaying(audio: AudioItem) -> Bool {
        return audio.id == currentPlayingAudio?.id
    }

    // first we add it to the playlist
    // then we start to play the first one
    func addToPlaylist(audios: [AudioItem]) {
        for audio in audios {
            print("Added to \(audio.title) to playlist.")
        }
    }
}

#Preview {
    ModelContainerPreview {
        try! ModelContainer.sample()
    } content: {
        AudioListView()
    }
}
