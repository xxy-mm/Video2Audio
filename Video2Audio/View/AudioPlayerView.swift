//
//  AudioPlayerView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/9.
//

import SwiftData
import SwiftUI

struct AudioPlayerView: View {
    var playlist: Playlist?
    @Binding var currentPlayingAudio: AudioItem?

    @Environment(\.modelContext) private var modelContext

    @State private var audioPlayer = AudioPlayer()
    @State private var showPlaylist = false
    @State private var playlistTitle = ""

    var title: String {
        audioPlayer.currentAudio?.title ?? ""
    }

    var body: some View {
        HStack {
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
                            .frame(width: 30, height: 30)
                    }
                    Button(action: {
                        audioPlayer.playNext()
                    }) {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Button {
                        showPlaylist = true
                    } label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }

            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray, radius: 3)
            .sheet(isPresented: $showPlaylist, content: {
                if let playlist {
                    PlaylistView(playlist: playlist)
                }
            })
            .onChange(of: audioPlayer.currentAudio, { _, newValue in
                currentPlayingAudio = newValue
            })
            .onChange(of: playlist, { oldValue, newValue in
                print("playlist changed:")
                print("old audios: \(oldValue?.audioItems.map { $0.title } ?? [nil])")
                print("new audios: \(newValue?.audioItems.map { $0.title } ?? [nil])")
                if let newValue {
                    audioPlayer.setAudios(newValue.audioItems)
                } else {
                    audioPlayer.setAudios([])
                }

            })
            .task {
                if let playlist {
                    audioPlayer.setAudios(playlist.audioItems)
                } else {
                    audioPlayer.setAudios([])
                }
            }
        }
        .padding(.horizontal)
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

#Preview("multiple audios") {
    AudioPlayerView(playlist: Playlist(title: "list1", audioItems: AudioItem.sampleData.suffix(3)), currentPlayingAudio: .constant(nil))
}

#Preview("single audio") {
    AudioPlayerView(playlist: Playlist(title: "list2", audioItems: AudioItem.sampleData.suffix(1)), currentPlayingAudio: .constant(nil))
}
