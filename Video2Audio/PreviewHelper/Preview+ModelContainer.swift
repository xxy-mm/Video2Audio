/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An extension that creates a sample model container to use when previewing
 views in Xcode.
*/

import SwiftData

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([AudioItem.self, Playlist.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            AudioItem.insertSampleData(modelContext: container.mainContext)
            Playlist.insertSampleData(modelContext: container.mainContext)
        }
        return container
    }

}
