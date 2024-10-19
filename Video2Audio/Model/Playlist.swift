//
//  Playlist.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/19.
//

import Foundation
import SwiftData

@Model
final class Playlist {
    var id = UUID()
    var title: String
    var audioIds: [UUID]
    var currentIndex: Int

    init(title: String, audioIds: [UUID], currentIndex: Int = 0) {
        self.title = title
        self.audioIds = audioIds
        self.currentIndex = currentIndex
    }
}

extension Playlist {
    static var sampleData: [Playlist]{
        [
            Playlist(title: "example playlist1", audioIds: AudioItem.sampleData.prefix(10).map { $0.id }),
            Playlist(title: "example playlist2", audioIds: AudioItem.sampleData.suffix(5).map { $0.id }),
        
        ]
    }
    
    static func insertSampleData(modelContext: ModelContext) {
        sampleData.forEach { playlist in
            modelContext.insert(playlist)
        }
    }
}
