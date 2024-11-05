//
//  ModelSchemaV1.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/22.
//

import Foundation
import SwiftData

typealias SchemaLatest = VersionedSchemaV1
typealias AudioItem = SchemaLatest.AudioItem
typealias Playlist = SchemaLatest.Playlist
typealias ConvertionTask = SchemaLatest.ConvertionTask

enum VersionedSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [AudioItem.self, Playlist.self, ConvertionTask.self]
    }

    static let versionIdentifier: Schema.Version = Schema.Version(0, 0, 2)

    @Model
    class AudioItem {
        @Attribute(.unique)
        var id: UUID
        var status: VideoConvertStatus
        var sourceURL: URL
        var url: URL
        var title: String
        var isFavorite: Bool?
        var task: ConvertionTask?
        var coverImage: URL?
        var desc: String
        var createdAt: Date = Date.now
        var lastPlayedAt: Date?
        
        init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing, isFavorite: Bool = false, id: UUID = UUID(), description: String = "", coverImage: URL? = nil) {
            sourceURL = videoURL
            url = audioURL
            self.status = status
            title = audioURL.lastPathComponent
            self.isFavorite = isFavorite
            self.id = id
            desc = description
            self.coverImage = coverImage
        }
    }

    @Model
    class ConvertionTask {
        var id: UUID
        var createAt: Date = Date.now
        @Relationship(deleteRule: .cascade, inverse: \AudioItem.task)
        var audioItems: [AudioItem] = []
        var title: String
        var lastPlayedAt: Date?
        var desc: String

        init(title: String = Date.now.formatted(), id: UUID = UUID(), desc: String = "") {
            self.id = id
            self.title = title
            self.desc = desc
        }
    }

    @Model
    final class Playlist {
        @Attribute(.unique)
        var id: UUID
        var title: String
        var desc: String
        var coverImage: URL?
        @Relationship(deleteRule: .noAction)
        var audios: [AudioItem] = []
        var isFavorite: Bool?
        var createdAt: Date = Date.now
        var lastPlayedAt: Date?
        
        init(title: String, audioItems: [AudioItem] = [], isFavorite: Bool = false, id: UUID = UUID(), description: String = "", coverImage: URL? = nil) {
            self.title = title
            audios = audioItems
            self.isFavorite = isFavorite
            self.id = id
            desc = description
            self.coverImage = coverImage
        }
    }
}

