//
//  AduioPlayerState.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/24.
//

import Foundation

protocol AudioPlayerState {
    var audioPlayer: AudioPlayer { get }
    init(audioPlayer: AudioPlayer)

    func play()

    func pause()

    /// play the next audio of the playlist
    func next()
    /// play the audio at the currentIndex of the audioItem list
    func playAt(_ index: Int)

    /// set the audio items of the audio player
    /// - Parameters
    ///     - audioItems:  the new list of audios to play
    ///     - playAtIndex: the index of the audio in the list to play
    ///     - keepIndex: whether to keep the audio player's currentIndex after new audioItems are set
    func setAudios(_ audioItems: [AudioItem], _ playAtIndex: Int, keepIndex: Bool)
}

extension AudioPlayerState {
    func play() {
        print("play...")
    }

    func pause() {
        print("pause...")
    }

    func next() {
        print("next...")
    }

    /// When setting a brand new playlist, we should
    /// 1. first stop the current playing audio, using resetPlayer which stop and set the player to nil
    /// 2. set the audio items
    /// 3. update the currentIndex
    /// 4. update the state, the state after this action can be one of [noplaylist, hasplaylist, haserror]
    func setAudios(_ audioItems: [AudioItem], _ playAtIndex: Int = 0, keepIndex: Bool = false) {
        audioPlayer.resetPlayer()
        audioPlayer.audioItems = audioItems

        if !keepIndex {
            if playAtIndex >= 0 && playAtIndex < audioItems.count {
                audioPlayer.currentIndex = playAtIndex
            } else {
                print("currentIndex exceeds the length of audioItems, the given index: \(playAtIndex), the count of audioItems: \(audioItems.count)")
                audioPlayer.currentIndex = 0
            }
        }

        if audioItems.count > 0 {
            audioPlayer.state = audioPlayer.hasPlaylistState
            guard let _ = try? audioPlayer.loadAudioFile(at: playAtIndex) else {
                audioPlayer.state = audioPlayer.hasErrorState
                return
            }
        } else {
            audioPlayer.state = audioPlayer.noPlaylistState
        }

        
    }

    func playAt(_ index: Int) {
        guard index != audioPlayer.currentIndex else {
            return
        }
        audioPlayer.currentIndex = index
        if let _ = try? audioPlayer.loadAudioFile(at: index) {
            audioPlayer.player?.play()
            audioPlayer.state = audioPlayer.isPlayingState
        } else {
            audioPlayer.state = audioPlayer.hasErrorState
        }
    }
}

/// This is the initial state when init the audio player with the default constructor
/// It makes no sence to perform any actions other than setAudios
struct NoPlaylistState: AudioPlayerState {
    var audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func playAt(_ index: Int) {
        print("no audio to play")
    }
}

/// This is the initial state when init the audio player using the convinience initializer or after setAudios has called.
/// It can perform play, next actions along with setAudios.
struct HasPlaylistState: AudioPlayerState {
    var audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func play() {
        audioPlayer.player!.play()
        audioPlayer.state = audioPlayer.isPlayingState
    }

    func next() {
        guard let _ = try? audioPlayer.incrementIndex() else {
            audioPlayer.state = audioPlayer.hasErrorState
            return
        }
    }
}

/// pause, next
struct IsPlayingState: AudioPlayerState {
    var audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func pause() {
        audioPlayer.player?.pause()
        audioPlayer.state = audioPlayer.isPausedState
    }

    func next() {
        guard let _ = try? audioPlayer.incrementIndex() else {
            audioPlayer.state = audioPlayer.hasErrorState
            return
        }
        audioPlayer.player?.play()
    }
}

// play, next
struct IsPausedState: AudioPlayerState {
    var audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func play() {
        audioPlayer.player!.play()
        audioPlayer.state = audioPlayer.isPlayingState
    }

    func next() {
        guard let _ = try? audioPlayer.incrementIndex() else {
            audioPlayer.state = audioPlayer.hasErrorState
            return
        }
    }
}

struct HasErrorState: AudioPlayerState {
    var audioPlayer: AudioPlayer

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    func next() {
        guard let _ = try? audioPlayer.incrementIndex() else {
            return
        }
        audioPlayer.player?.play()
        audioPlayer.state = audioPlayer.isPlayingState
    }
}
