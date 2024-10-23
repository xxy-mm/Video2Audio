//
//  ModelSchemaV1.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/22.
//

import Foundation
import SwiftData

typealias SchemaLatest = VersionedSchemaV2
typealias AudioItem = SchemaLatest.AudioItem
typealias Playlist = SchemaLatest.Playlist

enum VersionedSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [AudioItem.self, Playlist.self]
    }
    
    static var versionIdentifier: Schema.Version = Schema.Version(0,0,1)
    
    @Model
    class AudioItem {
        var id = UUID()
        var status: VideoConvertStatus
        var sourceURL: URL
        var url: URL
        var title: String
        init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing) {
            self.sourceURL = videoURL
            self.url = audioURL
            self.status = status
            self.title = audioURL.lastPathComponent
        }
    }
    
    @Model
    final class Playlist {
        var id = UUID()
        var title: String
        @Relationship(deleteRule: .noAction)
        var audioItems: [AudioItem] = []
        var currentIndex: Int

        init(title: String, audioItems: [AudioItem]=[], currentIndex: Int = 0) {
            self.title = title
            self.audioItems = audioItems
            self.currentIndex = currentIndex
        }
    }
}


enum VersionedSchemaV2: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [AudioItem.self, Playlist.self]
    }
    
    static var versionIdentifier: Schema.Version = Schema.Version(0,0,2)
    
    @Model
    class AudioItem {
        @Attribute(.unique)
        var id = UUID()
        var status: VideoConvertStatus
        var sourceURL: URL
        var url: URL
        var title: String
        var isFavorite: Bool?
        init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing, isFavorite: Bool = false) {
            self.sourceURL = videoURL
            self.url = audioURL
            self.status = status
            self.title = audioURL.lastPathComponent
            self.isFavorite = isFavorite
        }
    }
    
    @Model
    final class Playlist {
        @Attribute(.unique)
        var id = UUID()
        var title: String
        
        @Relationship(deleteRule: .noAction)
        var audioItems: [AudioItem] = []
        
        var currentIndex: Int
        var isFavorite: Bool?
        init(title: String, audioItems: [AudioItem]=[], currentIndex: Int = 0, isFavorite: Bool = false) {
            self.title = title
            self.audioItems = audioItems
            self.currentIndex = currentIndex
            self.isFavorite = isFavorite
        }
    }
}

