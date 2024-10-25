//
//  AudioPlayerTests.swift
//  Video2AudioTests
//
//  Created by xxy-mm on 2024/10/16.
//

import AVFoundation
@testable import Video2Audio
import XCTest

final class AudioPlayerSingleAudioTests: XCTestCase {
    private var audioPlayer: AudioPlayer!
    private var testBundle: Bundle!
    private var invalidAudioItems: [AudioItem]!
    private var audioItems: [AudioItem]!
    private var audioItem1: AudioItem!
    private var audioItem2: AudioItem!
    
    override func setUpWithError() throws {
        audioPlayer = AudioPlayer()
        testBundle = Bundle(for: type(of: self))
        audioItem1 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "a", withExtension: "mp4")!)
        audioItem2 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "b", withExtension: "mp4")!)
        invalidAudioItems = AudioItem.sampleData
        audioItems = [audioItem1, audioItem2]
    }

    func testPropertyInitialValues() throws {
        XCTAssert(audioPlayer.isPlaying == false)
        XCTAssert(audioPlayer.currentIndex == 0)
        XCTAssert(audioPlayer.audioItems.isEmpty)
        XCTAssert(audioPlayer.currentAudio == nil)
        XCTAssert(audioPlayer.loopingStatus == .none)
        XCTAssert(audioPlayer.player == nil)
        XCTAssert(audioPlayer.state is NoPlaylistState)
    }

    /// When the playItems is set with invalid audios
    func testPlayInvalidAudio() {
        audioPlayer.setAudios(invalidAudioItems)
        audioPlayer.play()
        XCTAssert(audioPlayer.isPlaying == false, "Playing an invalid audio should not change the isPlaying to true")
        XCTAssert(audioPlayer.player == nil, "Playing an invalid audio should not create the player instance")
        XCTAssert(audioPlayer.currentIndex == 0, "Playing an invalid audio should not change the currentIndex")
        XCTAssert(audioPlayer.error != nil, "Playing an in valid audio should set error")
    }

    /// When the playItems is set with valid audios
    func testPlayValidAudio() {
        audioPlayer.setAudios(audioItems)
        audioPlayer.play()
        XCTAssert(audioPlayer.isPlaying == true, "Playing an audio should change the isPlaying to true")
        XCTAssert(audioPlayer.player != nil, "Playing an audio should create the player instance")
        XCTAssert(audioPlayer.state is IsPlayingState)
    }

    /// When the playItems is empty
    func testPlayEmptyList() {
        audioPlayer.setAudios([])
        audioPlayer.play()
        XCTAssert(audioPlayer.isPlaying == false, "Playing an invalid audio should not change the isPlaying to true")
        XCTAssert(audioPlayer.player == nil, "Playing an invalid audio should not create the player instance")
        XCTAssert(audioPlayer.currentIndex == 0, "Playing an invalid audio should not change the currentIndex")
        XCTAssert(audioPlayer.error == nil, "Playing an empty list should not produce errors")
    }

    // MARK: - looping

    // Single audio in playItems, with looping set to none
    func testLoopingNone() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.setAudios(audioItems)
        audioPlayer.play()
        audioPlayer.player?.currentTime = duration.seconds - 1
        audioPlayer.play()

        let expectation = self.expectation(description: "3 seconds")

        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == false, "isPlaying should set to false when audio reach the end")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    // looping:single
    func testLoopingSingle() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.setAudios(audioItems)
        audioPlayer.play()
        audioPlayer.loopingStatus = .single
        audioPlayer.player?.currentTime = duration.seconds - 1

        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the single audio")
        let expectation = self.expectation(description: "3 seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when audio reach the end")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should repeat the single audio")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    func testLoopingList() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.setAudios([audioItem1])
        audioPlayer.play()
        audioPlayer.loopingStatus = .list
        audioPlayer.player?.currentTime = duration.seconds - 1
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the single audio")
        let expectation = self.expectation(description: "3 seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when audio reach the end")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should repeat the single audio")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    // MARK: - playNext

    func testPlayNext() async {
        audioPlayer.setAudios([audioItem1])
        audioPlayer.play()
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the first audio")
        audioPlayer.playNext()
        XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when play next")
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should still play the single audio")
    }
}

// MARK: - AudioPlayer State

final class AudioPlayerStateTests: XCTestCase {
    private var audioPlayer1: AudioPlayer!
    private var audioPlayer2: AudioPlayer!
    private var testBundle: Bundle!
    private var audioItem1: AudioItem!
    private var audioItem2: AudioItem!
    private var audioList: [AudioItem]!
    private var invalidAudioItems: [AudioItem]!

    override func setUpWithError() throws {
        testBundle = Bundle(for: type(of: self))
        audioItem1 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "a", withExtension: "mp4")!)
        audioItem2 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "b", withExtension: "mp4")!)
        invalidAudioItems = AudioItem.sampleData
        audioList = [audioItem1, audioItem2]
        audioPlayer1 = AudioPlayer()
        audioPlayer2 = AudioPlayer(audioItems: audioList)
    }

    func testInitialState() {
        XCTAssert(audioPlayer1.state is NoPlaylistState, "the audio player's intial state should be no playlist state when create by default initializer")
        XCTAssert(audioPlayer2.state is HasPlaylistState, "the audio player's intial state should be has playlist state when create by convenience initializer")
    }

    func testHasPlaylistState() {
        audioPlayer1.setAudios([])
        XCTAssert(audioPlayer1.state is NoPlaylistState, "set empty array should not change the no playlist state")
        audioPlayer1.setAudios(audioList)
        XCTAssert(audioPlayer1.state is HasPlaylistState, "set non empty array should change the state to has playlist state")
    }

    func testIsPlayingState() {
        audioPlayer1.play()
        XCTAssert(audioPlayer1.state is NoPlaylistState, "playing with empty audioItems should not change the no playlist state")

        audioPlayer2.play()
        XCTAssert(audioPlayer2.state is IsPlayingState, "playing with non-empty audioItems should change the no playlist state to is playing state")
    }

    func testIsPausedState() {
        audioPlayer2.play()
        audioPlayer2.pause()
        XCTAssert(audioPlayer2.state is IsPausedState, "pause the playing audio should change the state to is paused state")
    }

    func testHasErrorState() {
        audioPlayer1.setAudios([invalidAudioItems.last!, audioItem1])
        audioPlayer1.play()
        XCTAssert(audioPlayer1.state is HasErrorState, "playing invalid audioItems should change the state to has error state")
        audioPlayer1.playNext()
        XCTAssert(audioPlayer1.state is IsPlayingState, "playing next valid audioItems from has error state  should change the state to is playing state")
    }
}

final class AudioPlayerMultiAudioTests: XCTestCase {
    private var audioPlayer: AudioPlayer!
    private var testBundle: Bundle!
    private var audioItem1: AudioItem!
    private var audioItem2: AudioItem!
    private var audioList: [AudioItem]!

    override func setUpWithError() throws {
        audioPlayer = AudioPlayer()
        testBundle = Bundle(for: type(of: self))
        audioItem1 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "a", withExtension: "mp4")!)
        audioItem2 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "b", withExtension: "mp4")!)
        audioList = [audioItem1, audioItem2]
    }

    // MARK: - looping

    // looping:single
    func testLoopingSingle() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.setAudios(audioList)
        audioPlayer.play()
        audioPlayer.loopingStatus = .single
        audioPlayer.player?.currentTime = duration.seconds - 1

        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the single audio")
        let expectation = self.expectation(description: "3 seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when audio reach the end")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should repeat the current audio")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    func testLoopingList() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.loopingStatus = .list
        audioPlayer.setAudios(audioList)
        // play the last audio in the list
        audioPlayer.currentIndex = audioList.count - 1
        audioPlayer.play()
        audioPlayer.player?.currentTime = duration.seconds - 1
        XCTAssert(audioPlayer.currentAudio?.id == audioItem2.id, "should play the first audio")
        let expectation = self.expectation(description: "3 seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when audio reach the end")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the next audio")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    // MARK: - playNext

    func testPlayNext() async {
        audioPlayer.setAudios(audioList)
        audioPlayer.play()
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the first audio")
        audioPlayer.playNext()

        XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when play next")
        XCTAssert(audioPlayer.currentAudio?.id == audioItem2.id, "should play the second audio")
    }
}
