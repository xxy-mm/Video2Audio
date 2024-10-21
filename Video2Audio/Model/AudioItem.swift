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
    static var ids = [
        "B0611DD6-E4F1-47F4-AE40-CDE92A7EA522",
        "61C40EEB-A708-4060-8157-641E370E61D8",
        "0FFB3E3B-C701-4404-920E-15DEE71818FB",
        "14BEC194-5933-4357-83D3-0F8BEDF93B09",
        "5A5AA97C-C180-4B80-A5AF-56C0FCA73FEC",
    ]
    static var sampleData: [AudioItem] {
        var items: [AudioItem] = []
        for (i, char) in "abcde".enumerated() {
            let item = AudioItem(videoURL: URL(string: "/ads/\(char).mp4")!, audioURL: URL(string: "/a/b/\(char).mp4")!)
            item.id = UUID(uuidString: ids[i])!
            if i < 1 {
                item.status = .processing
            } else if i < 3 {
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
