//
//  Video2AudioApp.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI
import SwiftData

@main
struct Video2AudioApp: App {
    @State private var modelContainer = try! ModelContainer(for: AudioItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
