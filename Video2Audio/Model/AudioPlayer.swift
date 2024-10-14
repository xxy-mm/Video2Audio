//
//  AudioPlayer.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/9.
//

import AVFoundation
import Foundation

@Observable
class AudioPlayer: NSObject {
    var player: AVAudioPlayer?
    var audios: [URL] = []
    var currentIndex = 0

    var isPlaying = false
    var isLooping = false

    
    func setAudios(audioURLs: [URL]) {
        audios = audioURLs
    }

    func loadAudioFile(at index: Int) {
        
        guard index < audios.count else {
            print("No Audios to play")
            return
        }
        let url = audios[index]
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
        } catch {
            print("Error loading audio file: \(error)")
            player?.stop()
            isPlaying = false
        }
    }

    // Play the current audio
    func play() {
        player?.play()
        isPlaying = true
    }

    // Pause the audio
    func pause() {
        player?.pause()
        isPlaying = false
    }

    // Resume audio playback
    func resume() {
        if let player = player, !player.isPlaying {
            player.play()
            isPlaying = true
        }
    }

    // Play the next track in the list
    func playNext() {
        currentIndex = (currentIndex + 1) % audios.count
        loadAudioFile(at: currentIndex)
        play()
    }

    // Toggle loop
    func toggleLoop() {
        isLooping.toggle()
    }
    
    func play(at index: Int) {
        guard index < audios.count else {
            print("Index out of range")
            return
        }
        currentIndex = index
        loadAudioFile(at: currentIndex)
        play()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isLooping {
            play()
        } else {
            if currentIndex + 1 < audios.count {
                playNext()
            }else {
                isPlaying = false
            }
        }
    }
}
