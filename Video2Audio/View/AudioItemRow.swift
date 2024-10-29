//
//  AudioItemRow.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/29.
//

import SwiftUI

struct AudioItemRow: View {
    var audioItem: AudioItem
    var showStatus = false
    var body: some View {
        HStack {
            Text(audioItem.title)
                .lineLimit(2)
                .truncationMode(.tail)
            Spacer()
            audioItem.icon.if(showStatus)
        }
    }
}

#Preview {
    AudioItemRow(audioItem: AudioItem.sampleData.last!)
}
