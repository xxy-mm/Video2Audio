//
//  AudioResult.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/6.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class AudioResult: Identifiable {
    var status: VideoConvertStatus
    var videoURL: URL
    var audioURL: URL
    var id = UUID()
    var title: String
    @Transient
    var icon: some View {
        switch status {
        case .processing:
            Image(systemName: "arrow.2.circlepath.circle").foregroundStyle(.green)
        case .success:
            Image(systemName: "checkmark.seal.fill").foregroundStyle(.blue)
        case .error:
            Image(systemName: "xmark.octagon").foregroundStyle(.red)
        }
    }

    init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing) {
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.status = status
        self.title = audioURL.lastPathComponent
    }
}

enum VideoConvertStatus: String, Codable, CaseIterable {
    case processing
    case success
    case error
}

extension AudioResult {
    static func insertSampleData(modelContext: ModelContext) {
        for (i, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
            let audioResult = AudioResult(videoURL: URL(string: "/ads/\(char).mp4")!, audioURL: URL(string: "/a/b/\(char).mp4")!)
            if i < 5 {
                audioResult.status = .processing
            }else if i < 8 {
                audioResult.status = .error
            }else {
                audioResult.status = .success
            }
            
            modelContext.insert(audioResult)
        }
    }
}
