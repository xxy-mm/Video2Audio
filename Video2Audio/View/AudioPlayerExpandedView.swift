//
//  AudioPlayerExpandedView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/31.
//

import SwiftData
import SwiftUI

// MARK: when user click an audio inside a playlist, the audioPlayer's setAudio method won't be called. The setAudio method is only called when click audios outside playlists. In the case an audio inside playlist is clicked, call the updateIndex method of the audioPlayer

struct AudioPlayerExpandedView: View {
    @State var audioItems: [AudioItem] = []
    var onDismiss: () -> Void
    @Environment(AudioPlayer.self) private var audioPlayer
    @State private var selectedAudio: AudioItem?

    var body: some View {
        NavigationStack {
            List(selection: $selectedAudio) {
                ForEach(audioItems) { audioItem in
                    HStack {
                        Text(audioItem.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                        Image(systemName: "line.horizontal.3")
                    }
                    .listRowBackground(Color.bg.opacity(0.3))
                    .tag(audioItem)
                }
                .onMove { from, to in
                    audioItems.move(fromOffsets: from, toOffset: to)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        audioItems.remove(at: index)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background {
                AppBackground()
            }
            .safeAreaInset(edge: .top) {
                VStack {
                    Rectangle()
                        .fill(Color.text.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .cornerRadius(3)
                        .padding(.bottom)
                        .onTapGesture {
                            onDismiss()
                        }

                    HStack {
                        Image("app-bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50, alignment: .topLeading)
                            .clipped()

                        VStack(alignment: .leading) {
                            Text(audioPlayer.currentAudio?.title ?? "")
                                .font(.title2)
                                .foregroundStyle(.text)
                            Text("Description")
                                .font(.caption)
                                .foregroundStyle(.text.opacity(0.6))
                        }
                        .lineLimit(1)
                        .truncationMode(.tail)

                        .padding(.horizontal)
                        Spacer()

                        Button {
                            let isFavorite = audioPlayer.currentAudio?.isFavorite == true
                            audioPlayer.currentAudio?.isFavorite = !isFavorite

                        } label: {
                            Image(systemName: (audioPlayer.currentAudio?.isFavorite ?? false) ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }

                        Menu {
                            NavigationLink {
                                if let audio = audioPlayer.currentAudio {
                                    EditAudioItemView(audioItem: audio)
                                }
                            } label: {
                                HStack {
                                    Text("Edit Infomation")
                                    Spacer()
                                    Image(systemName: "pencil")
                                }
                            }
                            Button {} label: {
                                HStack {
                                    Text("Share")
                                    Spacer()
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.leading)
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    ProgressView(value: 0.3, total: 1)

                    HStack(alignment: .center, spacing: 60) {
                        Button {} label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(width: 40, height: 30)
                        }
                        Button {} label: {
                            Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        Button {} label: {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(width: 40, height: 30)
                        }
                    }
                }
            }
            .onChange(of: selectedAudio) { _, newValue in
                guard let audio = newValue else { return }
                if let index = audioPlayer.audioItems.firstIndex(of: audio) {
                    audioPlayer.playAt(index)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var audioPlayer = AudioPlayer(audioItems: AudioItem.sampleData)

    AudioPlayerExpandedView(onDismiss: {
        print("onDismiss")
    })
    .modelContainer(ModelContainer.previewContainer)
    .environment(audioPlayer)
}
