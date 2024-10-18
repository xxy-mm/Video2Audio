//
//  AudioPlayerView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/9.
//

import SwiftData
import SwiftUI

struct AudioPlayerView: View {
    var playlist: [AudioItem]
    @Binding var currentPlayingAudio: AudioItem?
    @State private var audioPlayer = AudioPlayer()
    @State private var showPlaylist = false
    var title: String {
        audioPlayer.currentAudio?.title ?? ""
    }

    var body: some View {
        VStack {
            Text("Now Playing: \(title)")
                .font(.headline)
                .padding()

            HStack(spacing: 30) {
                Button(action: {
                    audioPlayer.changeLoop()
                }) {
                    loopImage()
                }

                Button(action: {
                    audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                }

                Button(action: {
                    audioPlayer.playNext()
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Button {
                    showPlaylist = true
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background()
        .sheet(isPresented: $showPlaylist, content: {
            NavigationStack{
                List {
                    
                    ForEach($audioPlayer.playlist) { $audio in
                        HStack {
                            Text(audio.title)
                            Spacer()
                            Image(systemName: "waveform")
                                .if(isPlaying(audio: audio))
                        }
                    }
                    .onMove { from, to in
                        audioPlayer.playlist.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { indices in
                        for index in indices {
                            audioPlayer.playlist.remove(at: index)
                        }
                    }
                }
                .listStyle(.plain)
                .padding()
                .toolbar {
                    EditButton()
                }
            }
        })
        .onChange(of: audioPlayer.currentAudio, { _, newValue in
            currentPlayingAudio = newValue
        })
        .onChange(of: playlist, { oldValue, newValue in
            print("playlist changed:")
            print("old audios: \(oldValue.map{$0.title})")
            print("new audios: \(newValue.map{$0.title})")
            audioPlayer.setAudios(playlist)
        })
        .onAppear {
            audioPlayer.setAudios(playlist)
        }
    }

    func isPlaying(audio: AudioItem) -> Bool {
        return audio.id == currentPlayingAudio?.id
    }

    func loopImage() -> some View {
        var imageName: String
        switch audioPlayer.loopingStatus {
        case .list:
            imageName = "repeat"
        case .single:
            imageName = "repeat.1"
        case .none:
            imageName = "repeat"
        }
        return Image(systemName: imageName)
            .resizable()
            .disabled(audioPlayer.loopingStatus == .none)
            .frame(width: 40, height: 40)
    }
}

#Preview {
    AudioPlayerView(playlist: AudioItem.sampleData, currentPlayingAudio: .constant(nil))
}
