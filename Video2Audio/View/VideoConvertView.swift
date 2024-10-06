//
//  VideoConvertView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import AVFoundation
import SwiftUI

struct VideoConvertView: View {
    @State private var converter: MVideoConverter = MVideoConverter()
    @State var videoURLs: [URL]
    @State private var isExporting = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isConverting = false
    var body: some View {
        List {
            ForEach($converter.audioResults) { $result in
                HStack {
                    Text("\(result.audioURL.lastPathComponent)")
                    Spacer()
                    statusImage(status: result.status)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Convert") {
                    startConvert()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    isExporting = true
                } label: {
                    Text("Export")
                }
                .fileExporter(isPresented: $isExporting, documents: converter.audioResults.map { AudioFile(url: $0.audioURL) }, contentType: .mpeg4Audio, onCompletion: exportHandler)
            }
        }
        .alert("Export Status", isPresented: $showAlert, actions: {
        }, message: {
            Text(alertMessage)
        })
        .navigationTitle("Converting...")
        .task {
            converter.initAudioResults(video: videoURLs)
        }
    }

    func startConvert() {
        Task {
            await converter.convert(video: videoURLs)
        }
        isConverting = true
    }

    func exportHandler(result: Result<[URL], any Error>) {
        switch result {
        case let .success(url):
            alertMessage = "Success saved file to \(url)"
        case let .failure(error):
            alertMessage = "Failed to save file: \(error.localizedDescription)"
        }

        showAlert = true
    }

    func statusImage(status: VideoConvertStatus) -> some View {
        let image: Image
        let color: Color

        switch status {
        case .error:
            image = Image(systemName: "xmark.octagon")
            color = .red

        case .success:
            image = Image(systemName: "checkmark.seal.fill")
            color = .blue

        case .processing:
            image = Image(systemName: "arrow.2.circlepath.circle")
            color = .green
        }

        return image
            .foregroundColor(color)
            .rotationEffect(.degrees(360) )
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: status)
    }
}

// Custom Document type for exporting audio
struct AudioFile: FileDocument {
    static var readableContentTypes: [UTType] { [.mpeg4Audio] }
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
        VideoConvertView(videoURLs: [])
    }
}
