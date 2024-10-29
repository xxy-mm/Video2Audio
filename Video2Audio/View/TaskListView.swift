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
    
    @Environment(\.modelContext) private var context
    @Environment(\.editMode) private var editMode
    
    @State private var showDeleteAlert = false
    @State private var taskIndicesToDelete: IndexSet = []
    
    var body: some View {
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        AudioItemListView(audioItems: task.audioItems, title: task.title)
                    } label: {
                        HStack {
                            Text(task.title)
                            Spacer()
                        }
                    }
                    .foregroundStyle(.text)
                    .listRowBackground(Color.bg)
                }
                .onDelete { indexSet in
                    showDeleteAlert = true
                    taskIndicesToDelete = indexSet
                }
            }
            .scrollContentBackground(.hidden)
            .background(content: {
                AppBackground()
            })
            .alert("delete task", isPresented: $showDeleteAlert, actions: {
                Button("Confirm") {
                    deleteTask(indexSet: taskIndicesToDelete)
                    taskIndicesToDelete = []
                }
                Button("Cancel") {
                    taskIndicesToDelete = []
                }
                
            }, message: {
                Text("Deleting a task will also delete all audios of the task, are you sure?")
            })
            .toolbar {
                EditButton()
            }
            .navigationTitle("Tasks")
        
    }
    
    
    func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(tasks[index])
        }
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
