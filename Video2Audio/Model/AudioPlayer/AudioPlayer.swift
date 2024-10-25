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
    var audioItems: [AudioItem] = []
    var currentIndex = 0
    var loopingStatus = LoopingStatus.none
    var error: (any Error)?

    @ObservationIgnored var noPlaylistState: NoPlaylistState!
    @ObservationIgnored var hasPlaylistState: HasPlaylistState!
    @ObservationIgnored var isPlayingState: IsPlayingState!
    @ObservationIgnored var isPausedState: IsPausedState!
    @ObservationIgnored var hasErrorState: HasErrorState!

    var state: AudioPlayerState!

    override init() {
        super.init()
        noPlaylistState = NoPlaylistState(audioPlayer: self)
        hasPlaylistState = HasPlaylistState(audioPlayer: self)
        isPlayingState = IsPlayingState(audioPlayer: self)
        isPausedState = IsPausedState(audioPlayer: self)
        hasErrorState = HasErrorState(audioPlayer: self)
        state = noPlaylistState
    }

    convenience init(audioItems: [AudioItem], playAt index: Int = 0) {
        self.init()
        setAudios(audioItems, index)
    }
}

extension AudioPlayer {
    var currentAudio: AudioItem? {
        guard currentIndex >= 0 && currentIndex < audioItems.count else {
            return nil
        }
        return audioItems[currentIndex]
    }

    var isPlaying: Bool {
        state is IsPlayingState
    }

    func loadAudioFile(at index: Int) throws {
        guard index >= 0 && index < audioItems.count else {
            throw AudioPlayerError.outOfRange
        }
        resetPlayer()
        let url = audioItems[index].url
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
        } catch {
            self.error = error
            throw error
        }
    }

    /// play the audio
    func play() {
        state.play()
    }

    /// Pause the audio
    func pause() {
        state.pause()
    }

    /// Play the next audio in the list
    func playNext() {
        state.next()
    }

    /// change loop status
    func changeLoop() {
        let index = LoopingStatus.all.firstIndex(of: loopingStatus)!
        let next = (index + 1) % LoopingStatus.all.count
        loopingStatus = LoopingStatus.all[next]
    }

    /// play the audio at specified index
    func playAt(_ index: Int) {
        state.playAt(index)
    }

    func resetPlayer() {
        player?.stop()
        player = nil
    }

    func setAudios(_ audioItems: [AudioItem], _ currentIndex: Int = 0, keepIndex: Bool = false) {
        state.setAudios(audioItems, currentIndex, keepIndex: keepIndex)
    }

    func incrementIndex() throws {
        resetPlayer()
        currentIndex = (currentIndex + 1) % audioItems.count
        try loadAudioFile(at: currentIndex)
    }
}

// MARK: - Errors

extension AudioPlayer {
    enum AudioPlayerError: Error, Codable {
        case outOfRange
        case invalidAudio

        var rawValue: String {
            switch self {
            case .outOfRange:
                return "index out of range"
            case .invalidAudio:
                return "audio file is invalid"
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    /// this method is called automatically after the current audio finished playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        state = isPausedState
        switch loopingStatus {
        case .single:
            play()
        case .list:
            state = isPlayingState
            playNext()
        default:
            break
        }
    }
}
