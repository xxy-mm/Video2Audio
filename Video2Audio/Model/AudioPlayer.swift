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
    var playlist: [AudioItem] = []
    var currentIndex = 0
    var isPlaying = false
    var loopingStatus = LoopingStatus.none
    var error: (any Error)?

    func setAudios(_ audios: [AudioItem]) {
        stop()
        playlist = audios
        play()
    }

    /// stop the audio. This will set player to nil
    /// if you only want to stop the audio without reset the player to nil, use pause instead
    private func stop() {
        invalidateCurrentPlayer()
        currentIndex = 0
    }

    private func invalidateCurrentPlayer() {
        player?.stop()
        player = nil
        isPlaying = false
    }

    func loadAudioFile(at index: Int) -> Bool {
        guard index >= 0 && index < playlist.count else {
            print("No audio to play")
            return false
        }
        let url = playlist[index].url
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            return true
        } catch {
            print("Error loading audio file: \(error)")
            self.error = error
            return false
        }
    }

    /// Play the audio at  the currentIndex of the playList
    /// situations:
    /// 1. the player is nil:
    ///     1. the player is nil by default, which means the playlist has not started playing yet.
    ///     2. the player is set to nil by the stop() method.
    ///         1. the playlist is changed
    ///         2. the playlist reaches the end and loopingStatus is .none
    /// 3. the player is not nil, which means the playlist has been started
    ///     1.isPlaying is true: the audio is currently playing, calling this method does nothing
    ///     2.isPlaying is false: the audio is paused, calling this method will resume the playing
    func play() {
        if let player, !isPlaying {
            player.play()
            isPlaying = true
        } else {
            if loadAudioFile(at: currentIndex) {
                player?.play()
                isPlaying = true
            }
        }
    }

    /// play the audio at specified index
    /// this should only be called when tap in the playlist menu, not the AudioListView
    // TODO: play audio at specified index of the playlist
    func playAt(index: Int) {
    }

    /// resume the audio when it is paused

    // Pause the audio
    func pause() {
        player?.pause()
        isPlaying = false
    }

    // Play the next audio in the list
    func playNext() {
        /// if it is the last audio in the playlist and looping status is none
        /// call the playNext will do nothing
        /// but leave it now and add a todo
        // TODO: handle the case when the audio list reaches the end
        /*
        if currentIndex + 1 == playlist.count,
           loopingStatus == .none {
            return
        }
         */

        currentIndex = (currentIndex + 1) % playlist.count
        invalidateCurrentPlayer()
        play()
    }

    // Toggle loop
    func changeLoop() {
        let index = LoopingStatus.all.firstIndex(of: loopingStatus)!
        let next = (index + 1) % LoopingStatus.all.count
        loopingStatus = LoopingStatus.all[next]
    }
}

// MARK: - get the current playing audio item, so we can retrive its attributes like title, etc...

extension AudioPlayer {
    var currentAudio: AudioItem? {
        guard currentIndex >= 0 && currentIndex < playlist.count else {
            return nil
        }
        return playlist[currentIndex]
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    /// this method is called automatically after the current audio finished playing
    /// but it makes no sence if user can't see the current playlist
    // TODO: PlayList
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch loopingStatus {
        case .single:
            play()
        case .list:
            playNext()
        default:
            stop()
        }
    }

    // TODO: handle decode error and interruptions
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        print("--------------, error ocurred! \(error?.localizedDescription ?? "")")
    }
}
