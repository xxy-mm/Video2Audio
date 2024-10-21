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
    @Relationship(deleteRule: .noAction, inverse: nil)
    var audioItems: [AudioItem] = []
    var currentIndex: Int

    init(title: String, audioItems: [AudioItem]=[], currentIndex: Int = 0) {
        self.title = title
        self.audioItems = audioItems
        self.currentIndex = currentIndex
    }
}

extension Playlist {
    static var sampleData: [Playlist]{
        [
            Playlist(title: "example playlist1"),
            Playlist(title: "example playlist2"),
        
        ]
    }
    
    static func insertSampleData(modelContext: ModelContext) {
        sampleData.forEach { playlist in
            modelContext.insert(playlist)
        }
    }
}
