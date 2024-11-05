//
//  EditAudioItemView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/31.
//

import SwiftData
import SwiftUI

struct EditAudioItemView: View {
    @Bindable var audioItem: AudioItem
    @State private var title: String = ""
    @State private var description: String = ""

    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Form {
            Section("Title") {
                AutoHeightTextEditor(text: $title)
            }
            Section("Description") {
                AutoHeightTextEditor(text: $title)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button {
                    audioItem.title = title
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .onAppear {
            title = audioItem.title
            description = audioItem.title
        }
        .navigationTitle("Edit Audio")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    @Previewable @State var audioItem = AudioItem.sampleData.last!
    NavigationStack {
        EditAudioItemView(audioItem: audioItem)
    }
}
