//
//  AudioResult.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/6.
//

import Foundation
import SwiftData

@Observable
class AudioResult: Identifiable {
    var status: VideoConvertStatus
    var videoURL: URL
    var audioURL: URL
    var id = UUID()

    init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing) {
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.status = status
    }
}

enum VideoConvertStatus {
    case processing
    case success
    case error
}
