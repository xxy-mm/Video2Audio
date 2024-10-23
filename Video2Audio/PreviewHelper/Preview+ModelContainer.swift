/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 An extension that creates a sample model container to use when previewing
  views in Xcode.
 */

import Foundation
import os
import SwiftData

extension ModelContainer {
    static let logger = Logger(subsystem: "com.xxy-mm.Video2Audio", category: "App")
    // HINT: logger statements are optional

    static func setupModelContainer(for versionedSchema: VersionedSchema.Type = SchemaLatest.self, url: URL? = nil, rollback: Bool = false) throws -> ModelContainer {
        do {
            logger.info("setup - versionedSchema: \(String(describing: versionedSchema))")

            // schema
            let schema = Schema(versionedSchema: versionedSchema)
            logger.info("setup - schema: \(String(describing: schema))")

            // config
            var config: ModelConfiguration
            if let url = url {
                config = ModelConfiguration(schema: schema, url: url)
            } else {
                config = ModelConfiguration(schema: schema)
            }
            logger.info("setup - config: \(String(describing: config))")

            // container
            let container = try ModelContainer(
                for: schema,
                migrationPlan: MigrationPlanV1toV2.self,
                configurations: [config]
            )
            logger.info("setup -> \(String(describing: container))")

            return container
        } catch {
            logger.error("setup - \(error)")
            throw error
        }
    }

    static func loadSampleDataSchemaV1(context: ModelContext) throws {
        typealias AudioItem = VersionedSchemaV1.AudioItem
        typealias Playlist = VersionedSchemaV1.Playlist
        let audioItems = {
            var ids = [
                "B0611DD6-E4F1-47F4-AE40-CDE92A7EA522",
                "61C40EEB-A708-4060-8157-641E370E61D8",
                "0FFB3E3B-C701-4404-920E-15DEE71818FB",
                "14BEC194-5933-4357-83D3-0F8BEDF93B09",
                "5A5AA97C-C180-4B80-A5AF-56C0FCA73FEC",
            ]
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
        }()
        let playlists = [
            Playlist(title: "example playlist1", audioItems: []),
            Playlist(title: "example playlist2", audioItems: []),
        ]

        audioItems.forEach { context.insert($0) }
        playlists.forEach { context.insert($0) }

        try context.save()
    }
}
