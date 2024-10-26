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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelContainer.previewContainer)
        }
    }
}
