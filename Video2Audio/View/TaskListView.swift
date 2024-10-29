//
//  TaskListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/29.
//

import SwiftData
import SwiftUI
struct TaskListView: View {
    @Query private var tasks: [ConvertionTask]
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink {
                    AudioItemListView(task: task)
                } label: {
                    HStack {
                        Text(task.title)
                        Spacer()
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Tasks")
    }
}

struct AudioItemListView: View {
    @Bindable var task: ConvertionTask
    var body: some View {
        List {
            ForEach(task.audioItems){ audioItem in
                AudioItemRow(audioItem: audioItem, showStatus: true)
            }
        }
        .listStyle(.plain)
        .navigationTitle(task.title)
    }
}

#Preview {
    let modelContaienr = ModelContainer.previewContainer
    let context = modelContaienr.mainContext
    let tasks = [
        ConvertionTask(title: "asdsfasdf"),
        ConvertionTask(title: "asafddddd"),
    ]
    tasks.forEach { context.insert($0) }
    
    tasks[0].audioItems.append(AudioItem.sampleData[0])
    tasks[1].audioItems.append(contentsOf:  AudioItem.sampleData.suffix(2))
    return NavigationStack { TaskListView()
        .modelContainer(modelContaienr)
    }
}
