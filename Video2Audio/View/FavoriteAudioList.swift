//
//  FavoriteAudioList.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/30.
//

import SwiftUI
import SwiftData

struct FavoriteAudioList: View {
    @Query private var audioItems: [AudioItem]
    var body: some View {
        List {
            ForEach(audioItems) { audioItem in
                AudioItemRow(audioItem: audioItem)
                    .foregroundStyle(Color.text)
                    .listRowBackground(Color.bg)
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            AppBackground()
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoriteAudioList()
}
