//
//  AudioListView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/4.
//

import SwiftUI

struct AudioListView: View {
    @State private var audios = ["1.mp3", "2.mp3", "3.mp3"]
    @State private var showVideoPicker = false
    @State private var showConvertView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(audios, id: \.self) { audio in
                    Text(audio)
                }
                .onDelete { indices in
                    for index in indices {
                        audios.remove(at: index)
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        showVideoPicker = true
                    }label: {
                        Image(systemName: "plus")
                    }
                    .fileImporter(isPresented: $showVideoPicker, allowedContentTypes: [.movie, .mpeg4Movie, .avi, .quickTimeMovie], allowsMultipleSelection: false) { result in
                        do {
                            let result = try result.get()
                            print("Result: \(result)")
                            // TODO: convert video to audio
                            // 1. navigate to convert view
                            showConvertView = true
                            // 2. list all imported videos
                            // 3. start converting, and show status at each row
                            
                        }catch {
                            print("Failed to get result: \(error.localizedDescription)")                        }
                    }
                }
            }
            .navigationTitle("Audios")
            .navigationDestination(isPresented: $showConvertView) {
                VideoConvertView()
            }
        }
    }
}

#Preview {
    AudioListView()
}
