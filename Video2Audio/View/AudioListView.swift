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
                                waveFormIcon(audio)
                                audio.icon
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    if editMode == .active {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(hasSelectAll ? "DeSelect All" : " Select All") {
                                hasSelectAll ? selectedAudios.removeAll() : selectedAudios.append(contentsOf: audios)
                                hasSelectAll.toggle()
                                print(selectedAudios.count)
                            }
                        }
                    }

                    ToolbarItem {
                        Button {
                            if editMode == .active {
                                editMode = .inactive
                            } else {
                                editMode = .active
                            }
                        } label: {
                            Text(editMode == .inactive ? "Edit" : "Done")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            showVideoPicker = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .fileImporter(isPresented: $showVideoPicker, allowedContentTypes: [.mpeg, .mpeg2Video, .mpeg4Movie, .quickTimeMovie], allowsMultipleSelection: true) { result in
                            convertItems(result)
                        }
                    }
                }
                if showPlayerView {
                    VStack {
                        Spacer()
                        AudioPlayerView(audioIndexToPlay: $audioIndexToPlay)
                    }
                }

                if editMode == .active {
                    BatchActionBar {
                        
                    } onPlay: {
                        
                    } onDelete: {
                        for audio in selectedAudios {
                            modelContext.delete(audio)
                        }
                        editMode = .inactive
                    }
                }
            }
            .navigationTitle("Audios")
        }
    }
    
    @ViewBuilder
    func waveFormIcon(_ audio: AudioResult) -> some View {
        
            if let index = audios.firstIndex(of: audio),
               index == audioIndexToPlay,
               showPlayerView {
                Image(systemName: "waveform")
            }
        
    }

    func convertItems(_ result: Result<[URL], any Error>) {
        do {
            let urls = try result.get()
            print("Result: \(result)")
            let convertingItems = urls.map { AudioResult(videoURL: $0, audioURL: VideoConverter.getAudioURL(from: $0)) }
            startConvert(convertingItems: convertingItems)
        } catch {
            print("Failed to get result: \(error.localizedDescription)")
        }
    }

    func startConvert(convertingItems: [AudioResult]) {
        for item in convertingItems {
            let videoURL = item.videoURL
            let gotAccess = videoURL.startAccessingSecurityScopedResource()
            if !gotAccess {
                print("Failed to access security video files")
                return
            }
            let audioURL = item.audioURL
            print("audioURL: \(audioURL)")
            Task {
                if await VideoConverter.convertVideoToAudio(video: videoURL, audio: audioURL) {
                    item.status = .success
                } else {
                    item.status = .error
                }
                modelContext.insert(item)
                videoURL.stopAccessingSecurityScopedResource()
            }
        }
    }
    
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
    
    func delete(indexSet: IndexSet) {
        for index in indexSet {
            // TODO: also delete the file
            modelContext.delete(audios[index])
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
