//
//  AudioPlayerView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/9.
//

import SwiftUI
import SwiftData

struct AudioPlayerView: View {
    var audios: [AudioResult]
    @Binding var audioToPlay: Int
    @State var audioPlayer = AudioPlayer()
        var body: some View {
            VStack {
                Text("Now Playing: \(audios[audioToPlay].title)")
                    .font(.headline)
                    .padding()
                
                HStack(spacing: 30) {
                    Button(action: {
                        audioPlayer.toggleLoop()
                    }) {
                        Image(systemName: audioPlayer.isLooping ? "repeat.circle.fill" : "repeat.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    
                    Button(action: {
                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.resume()
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .disabled(audios.count == 0)
                    
                    Button(action: {
                        audioPlayer.playNext()
                    }) {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .disabled(audios.count < 2)
                    
                    
                }
            }
            .frame(maxWidth: .infinity)
            .background()
            .onChange(of: audioPlayer.currentIndex, { oldValue, newValue in
                // TODO: currentIndexChange -> get id of currentAudio -> pass to parent
                let newAudioId = audios[newValue].id
                audioToPlay = newValue
            })
            .onChange(of: audios, { oldValue, newValue in
                audioPlayer.setAudios(audioURLs: audios.map {$0.audioURL})
            })
            .onAppear {
                audioPlayer.setAudios(audioURLs: audios.map{$0.audioURL})
                audioPlayer.play(at: audioToPlay)
            }
        }
}

#Preview {
    AudioPlayerView(audios: [], audioToPlay: .constant(0))
}
