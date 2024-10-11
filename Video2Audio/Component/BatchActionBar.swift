//
//  BatchActionBar.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/11.
//

import SwiftUI

struct BatchActionBar: View {
    
    var onExport: (() -> Void)?
    var onPlay: (() -> Void)?
    var onDelete: (() -> Void)?
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if let onExport{
                    Button("Export") {
                        onExport()
                    }
                    Spacer()
                }
                
                if let onPlay {
                    Button("Play") {
                        onPlay()
                    }
                    Spacer()
                }
                
                if let onDelete{
                    Button("Delete") {
                        onDelete()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background()
        }
    }
}
