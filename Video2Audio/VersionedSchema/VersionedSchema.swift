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
typealias ConvertionTask = SchemaLatest.ConvertionTask


enum VersionedSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [AudioItem.self, Playlist.self]
    }

    static let versionIdentifier: Schema.Version = Schema.Version(0, 0, 1)

    @Model
    class AudioItem {
        var id: UUID
        var status: VideoConvertStatus
        var sourceURL: URL
        var url: URL
        var title: String
        init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing, id: UUID = UUID()) {
            sourceURL = videoURL
            url = audioURL
            self.status = status
            title = audioURL.lastPathComponent
            self.id = id
        }
    }

    @Model
    final class Playlist {
        var id: UUID
        var title: String
        @Relationship(deleteRule: .noAction)
        var audioItems: [AudioItem] = []
        var currentIndex: Int

        init(title: String, audioItems: [AudioItem] = [], currentIndex: Int = 0, id: UUID = UUID()) {
            self.title = title
            self.audioItems = audioItems
            self.currentIndex = currentIndex
            self.id = id
        }
    }
}

enum VersionedSchemaV2: VersionedSchema {
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
        init(videoURL: URL, audioURL: URL, status: VideoConvertStatus = .processing, isFavorite: Bool = false, id: UUID = UUID()) {
            sourceURL = videoURL
            url = audioURL
            self.status = status
            title = audioURL.lastPathComponent
            self.isFavorite = isFavorite
            self.id = id
        }
    }

    @Model
    class ConvertionTask {
        var id: UUID
        var createAt: Date = Date.now
        @Relationship(deleteRule: .cascade, inverse: \AudioItem.task)
        var audioItems: [AudioItem] = []
        var title: String

        init(title: String = Date.now.formatted(), id: UUID = UUID()) {
            self.id = id
            self.title = title
        }
    }

    @Model
    final class Playlist {
        @Attribute(.unique)
        var id: UUID
        var title: String

        @Relationship(deleteRule: .noAction)
        var audioItems: [AudioItem] = []

        var currentIndex: Int
        var isFavorite: Bool?

        init(title: String, audioItems: [AudioItem] = [], currentIndex: Int = 0, isFavorite: Bool = false, id: UUID = UUID()) {
            self.title = title
            self.audioItems = audioItems
            self.currentIndex = currentIndex
            self.isFavorite = isFavorite
            self.id = id
        }
    }
}
