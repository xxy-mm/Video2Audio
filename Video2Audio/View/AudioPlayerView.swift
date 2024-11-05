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
        HStack(spacing: 30) {
            Text("Now Playing: \(title)")
                .font(.headline)
                .foregroundStyle(Color.text)
                .padding()
            Button(action: {
                audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play()
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
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
        }

        .frame(maxWidth: .infinity)
        .background(Color.bg)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .gray, radius: 8)
        .onTapGesture {
            withAnimation {
                showPlaylist = true
            }
        }
        .sheet(isPresented: $showPlaylist) {
            AudioPlayerExpandedView(audioItems: playlist?.audios ?? []) {
                showPlaylist = false
            }
        }
        .onChange(of: audioPlayer.currentAudio, { _, newValue in
            currentPlayingAudio = newValue
        })
        .onChange(of: playlist, { oldValue, newValue in
            print("playlist changed:")
            print("old audios: \(oldValue?.audios.map { $0.title } ?? [nil])")
            print("new audios: \(newValue?.audios.map { $0.title } ?? [nil])")
            if let newValue {
                audioPlayer.setAudios(newValue.audios)
            } else {
                audioPlayer.setAudios([])
            }

        })
        .task {
            if let playlist {
                audioPlayer.setAudios(playlist.audios)
            } else {
                audioPlayer.setAudios([])
            }
        }

        .padding(.horizontal)
    }

    func isPlaying(audio: AudioItem) -> Bool {
        return audio.id == currentPlayingAudio?.id
    }
}

#Preview {
    @Previewable @State var currentAudio: AudioItem?

    AudioPlayerView(currentPlayingAudio: $currentAudio)
        .environment(AudioPlayer(audioItems: AudioItem.sampleData))
}
