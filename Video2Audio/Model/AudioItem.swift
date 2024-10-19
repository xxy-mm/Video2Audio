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
class AudioItem {
    var id = UUID()
    var status: VideoConvertStatus
    var sourceURL: URL
    var url: URL
    var title: String
    // If user delete the data, set this to false rather than delete it from swiftdata
    // But if this property is already set to true, which means it has already been deleted before, then delete it from swiftdata
    // TODO: if user exports the data, will the audioURL be changed?
    // TODO: if the user moves the video to another place, how to handle the videoURL?
    var isDeleted = false
    init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing) {
        self.sourceURL = videoURL
        self.url = audioURL
        self.status = status
        self.title = audioURL.lastPathComponent
    }
}

// MARK: - properties for swiftUI
extension AudioItem {
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
}

// MARK: - sample data
extension AudioItem {
    
    static var sampleData: [AudioItem] {
        var items: [AudioItem] = []
        for (i, char) in "abcdefghijklmnopqrstuvwxyz".enumerated() {
            let item = AudioItem(videoURL: URL(string: "/ads/\(char).mp4")!, audioURL: URL(string: "/a/b/\(char).mp4")!)
            if i < 5 {
                item.status = .processing
            } else if i < 8 {
                item.status = .error
            } else {
                item.status = .success
            }

            items.append(item)
        }
        return items
    }
    static func insertSampleData(modelContext: ModelContext) {
        for item in sampleData {
            modelContext.insert(item)
        }
    }
}
