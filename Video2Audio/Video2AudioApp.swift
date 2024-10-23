//
//  Video2AudioApp.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftData
import SwiftUI

@main
struct Video2AudioApp: App {
    private var modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer.setupModelContainer()
        } catch {
            fatalError("Failed to initialize model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
