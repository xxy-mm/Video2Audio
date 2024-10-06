//
//  AudioListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI

struct AudioListView: View {
    @State private var audios = [AudioResult]()
    @State private var showVideoPicker = false
    @State private var showConvertView = false
    @State private var selectedVideoURLs = [URL]()

    var body: some View {
        NavigationStack {
            List {
                ForEach(audios) { audio in
                    Text(audio.audioURL.lastPathComponent)
                }
                .onDelete { indices in
                    for index in indices {
                        audios.remove(at: index)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showVideoPicker = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .fileImporter(isPresented: $showVideoPicker, allowedContentTypes: [.movie, .mpeg4Movie, .avi, .quickTimeMovie], allowsMultipleSelection: false) { result in
                        do {
                            let result = try result.get()
                            print("Result: \(result)")
                            selectedVideoURLs = result
                            showConvertView = true

                        } catch {
                            print("Failed to get result: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .navigationTitle("Audios")
            .navigationDestination(isPresented: $showConvertView) {
                VideoConvertView(videoURLs: selectedVideoURLs)
            }
        }
    }
}

#Preview {
    AudioListView()
}
