//
//  VideoConvertView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import AVFoundation
import SwiftUI

struct VideoConvertView: View {
    @State private var videos = ["1.mp4", "2.mov", "3.avi"]
    @State private var isExporting = false
    @State private var audioFileURL: URL?
    @State private var alertMessage = ""
    @State private var showAlert = false
    var body: some View {
        List {
            ForEach(videos, id: \.self) { video in
                Text(video)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    prepareAudioFile()
                    isExporting = true
                } label: {
                    Text("Export")
                }
                .fileExporter(isPresented: $isExporting, document: audioFileURL.map { AudioFile(url: $0) }, contentType: .movie) { result in
                    switch result {
                    case let .success(url):
                        alertMessage = "Success saved file to \(url.path)"
                    case let .failure(error):
                        alertMessage = "Failed to save file: \(error.localizedDescription)"
                    }

                    showAlert = true
                }
            }
        }
        .alert("Export Status", isPresented: $showAlert, actions: {
        }, message: {
            Text(alertMessage)
        })
        .navigationTitle("Converting...")
    }

    func prepareAudioFile() {
        //            let tempDirectory = FileManager.default.temporaryDirectory
        //            let audioURL = tempDirectory.appendingPathComponent("audio.m4a")
        guard let audioURL = getAudioFileURL() else { return }

        audioFileURL = audioURL
    }

    func getAudioFileURL() -> URL? {
        // Replace "sound" and "mp3" with your audio file name and extension
        if let fileURL = Bundle.main.url(forResource: "3", withExtension: "mov") {
            return fileURL
        } else {
            print("Audio file not found")
            return nil
        }
    }
}

// Custom Document type for exporting audio
struct AudioFile: FileDocument {
    static var readableContentTypes: [UTType] { [.movie] }
    var url: URL

    init(url: URL) {
        self.url = url
    }

    init(configuration: ReadConfiguration) throws {
        throw NSError() // Not used for exporting
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: url)
    }
}

#Preview {
    NavigationStack {
        VideoConvertView()
    }
}
