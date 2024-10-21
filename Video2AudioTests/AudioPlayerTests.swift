//
//  AudioPlayerTests.swift
//  Video2AudioTests
//
//  Created by xxy-mm on 2024/10/16.
//

@testable import Video2Audio
import XCTest
import AVFoundation

final class AudioPlayerSingleAudioTests: XCTestCase {
    
    private var audioPlayer: AudioPlayer!
    private var testBundle: Bundle!
    private var audioItem1: AudioItem!
    
    override func setUpWithError() throws {
        audioPlayer = AudioPlayer()
        testBundle = Bundle(for: type(of: self))
        audioItem1 = AudioItem(videoURL: URL(filePath: ""), audioURL: testBundle.url(forResource: "a", withExtension: "mp4")!)
        
    }
    // MARK: - initialization
    func testPropertyInitialValues() throws {
        
        XCTAssert(audioPlayer.isPlaying == false)
        XCTAssert(audioPlayer.currentIndex == 0)
        XCTAssert(audioPlayer.playItems.isEmpty)
        XCTAssert(audioPlayer.currentAudio == nil)
        XCTAssert(audioPlayer.loopingStatus == .none)
        XCTAssert(audioPlayer.player == nil)
    }
    // MARK: - set audios and play. The playItems auto starts playing after the playItems is set.
    /// When the playItems is set with invalid audios
    func testPlayInvalidAudio() {
        audioPlayer.setAudios(AudioItem.sampleData)
        XCTAssert(audioPlayer.isPlaying == false, "Playing an invalid audio should not change the isPlaying to true")
        XCTAssert(audioPlayer.player == nil, "Playing an invalid audio should not create the player instance")
        XCTAssert(audioPlayer.currentIndex == 0, "Playing an invalid audio should not change the currentIndex")
        XCTAssert(audioPlayer.error != nil, "Playing an in valid audio should set error")
    }
    
    /// When the playItems is set with valid audios
    func testPlayValidAudio() {
        audioPlayer.setAudios([audioItem1])
        XCTAssert(audioPlayer.isPlaying == true, "Playing an audio should change the isPlaying to true")
        XCTAssert(audioPlayer.player != nil, "Playing an audio should create the player instance")
    }
    /// When the playItems is empty
    func testPlayEmptyList() {
        audioPlayer.setAudios([])
        XCTAssert(audioPlayer.isPlaying == false, "Playing an invalid audio should not change the isPlaying to true")
        XCTAssert(audioPlayer.player == nil, "Playing an invalid audio should not create the player instance")
        XCTAssert(audioPlayer.currentIndex == 0, "Playing an invalid audio should not change the currentIndex")
        XCTAssert(audioPlayer.error == nil, "Playing an empty list should not produce errors")
    }
    
    // MARK: - looping
    // Single audio in playItems, with looping set to none
    func testLoopingNone() async {
        let duration = try! await AVURLAsset(url: audioItem1.url).load(.duration)
        audioPlayer.setAudios([audioItem1])
        audioPlayer.player?.currentTime = duration.seconds - 1
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
        audioPlayer.setAudios([audioItem1])
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
        let expectation = self.expectation(description: "3 seconds")
        
        audioPlayer.setAudios([audioItem1])
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the single audio")
        audioPlayer.playNext()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when play next")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should still play the single audio")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
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
        audioPlayer.setAudios(audioList)
        audioPlayer.loopingStatus = .list
        audioPlayer.player?.currentTime = duration.seconds - 1
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the single audio")
        let expectation = self.expectation(description: "3 seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when audio reach the end")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem2.id, "should play the next audio")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    
    // MARK: - playNext
    
    func testPlayNext() async {
        let expectation = self.expectation(description: "3 seconds")
        
        audioPlayer.setAudios(audioList)
        XCTAssert(audioPlayer.currentAudio?.id == audioItem1.id, "should play the first audio")
        audioPlayer.playNext()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [self] in
            XCTAssert(audioPlayer.isPlaying == true, "isPlaying should remain to be true when play next")
            XCTAssert(audioPlayer.currentAudio?.id == audioItem2.id, "should play the second audio")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
}
