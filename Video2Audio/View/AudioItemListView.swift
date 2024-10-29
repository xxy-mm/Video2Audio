//
//  AudioItemListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/30.
//

import SwiftData
import SwiftUI

struct AudioItemListView: View {
    var audioItems: [AudioItem]
    var title: String?
    
    @Environment(\.modelContext) private var context
    var body: some View {
        List {
            ForEach(audioItems) { audioItem in
                AudioItemRow(audioItem: audioItem, showStatus: true)
                    .foregroundStyle(.text)
                    .listRowBackground(Color.bg)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    context.delete(audioItems[index])
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            AppBackground()
        }
        .if(title != nil) { view in
            view.navigationTitle(title!)
        }
    }
}

#Preview {
    AudioItemListView(audioItems: AudioItem.sampleData, title: "Audio Items")
        .modelContainer(ModelContainer.previewContainer)
}
