//
//  AudioResult.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/6.
//

import Foundation
import SwiftData
import SwiftUI

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

extension AudioItem {
    static var sampleData: [AudioItem] {
        let ids = [
            "B0611DD6-E4F1-47F4-AE40-CDE92A7EA522",
            "61C40EEB-A708-4060-8157-641E370E61D8",
            "0FFB3E3B-C701-4404-920E-15DEE71818FB",
            "14BEC194-5933-4357-83D3-0F8BEDF93B09",
            "5A5AA97C-C180-4B80-A5AF-56C0FCA73FEC",
        ]
        var items: [AudioItem] = []
        for (i, char) in "abcde".enumerated() {
            let item = AudioItem(videoURL: URL(string: "/ads/\(char).mp4")!, audioURL: URL(string: "/a/b/\(char).mp4")!, id: UUID(uuidString: ids[i])!)
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
}
