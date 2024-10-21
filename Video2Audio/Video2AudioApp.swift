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
    @State private var modelContainer = try! ModelContainer.sample()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
