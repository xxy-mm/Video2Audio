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
    @State var audioPlayer = AudioPlayer()

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
            }
        }
        .frame(maxWidth: .infinity)
        .background()
       
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
