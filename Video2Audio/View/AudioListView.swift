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
    @Query(sort: \AudioResult.title) private var audios: [AudioResult]
    /// file importer
    @State private var showVideoPicker = false
    /// audio player
    @State private var audioIndexToPlay = 0
    @State private var showPlayerView = false
    @State private var playList = [AudioResult]()

    /// edit mode
    @State private var selectedAudios = [AudioResult]()
    @State private var editMode: EditMode = .inactive
    @State private var hasSelectAll = false
    /// file exporter
    @State private var audiosToExport = Set<AudioResult>()
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
            ZStack {
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
                                    .if(isPlaying(audio: audio))
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
                    AudioPlayerView(audios: selectedAudios, audioToPlay: $audioIndexToPlay)
                        .if(showPlayerView)
                })
                .safeAreaInset(edge: .bottom, content: {
                    BatchActionBar {
                    } onPlay: {
                    } onDelete: {
                        for audio in selectedAudios {
                            modelContext.delete(audio)
                        }
                        editMode = .inactive
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
                .fileExporter(isPresented: $showExporter, documents: audiosToExport.map { AudioFile(url: $0.audioURL) }, contentType: .mpeg4Audio) { result in
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
    }

    // MARK: - views

    func playButton(_ audio: AudioResult) -> some View {
        Group {
            Button {
                if editMode == .inactive,
                   audio.status == .success,
                   let index = audios.firstIndex(of: audio) {
                    audioIndexToPlay = index
                    showPlayerView = true
                }
            } label: {
                Text(audio.title)
            }
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
                    let item = AudioResult(videoURL: url, audioURL: audioURL)
                    modelContext.insert(item)
                    if await VideoConverter.convertVideoToAudio(video: item.videoURL, audio: item.audioURL) {
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

    func deleteAudio(_ audio: AudioResult) {
        // TODO: also delete the file
        modelContext.delete(audio)
    }

    func isPlaying(audio: AudioResult) -> Bool {
        if let index = audios.firstIndex(of: audio),
           index == audioIndexToPlay,
           showPlayerView {
            return true
        }
        return false
    }
}

#Preview {
    ModelContainerPreview {
        try! ModelContainer.sample()
    } content: {
        AudioListView()
    }
}
