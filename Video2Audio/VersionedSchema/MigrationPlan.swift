//
//  MigrationPlanV1ToV2.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/22.
//

import Foundation
import SwiftData

enum MigrationPlanV1toV2: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            VersionedSchemaV1.self,
            VersionedSchemaV2.self,
        ]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    static let migrateV1toV2 = MigrationStage.custom(fromVersion: VersionedSchemaV1.self, toVersion: VersionedSchemaV2.self) { _ in

    } didMigrate: { context in
        do {
            let items = try context.fetch(FetchDescriptor<VersionedSchemaV2.AudioItem>())
            let playlists = try context.fetch(FetchDescriptor<VersionedSchemaV2.Playlist>())
            items.forEach { $0.isFavorite = false }
            playlists.forEach { $0.isFavorite = false }
            print("migration finished.")
            
            try context.save()
        } catch {
            print("migration error: \(error.localizedDescription)")
        }
    }
}
