//
//  DraggableProgressView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/31.
//

import SwiftUI

struct DraggableProgressView: View {
    var total: CGFloat = 1
    @Binding var current: CGFloat
    
    private var progress: CGFloat  {
        current / total
    }
    
    private let barHeight: CGFloat = 5
    private let barColor: Color = Color.gray.opacity(0.3)
    private let barTintColor: Color = .blue
    private let barRadius: CGFloat = 4
    private let barPadding: CGFloat = 20
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background line
                    Rectangle()
                        .fill(barColor)
                        .frame(height: barHeight)

                    // Progress line
                    Rectangle()
                        .fill(barTintColor)
                        .frame(width: progress * geometry.size.width, height: barHeight)
                }
                .cornerRadius(barRadius) // Round edges of the progress line
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Calculate the progress based on drag location
                            var newProgress = value.location.x / geometry.size.width
                            newProgress = min(max(newProgress, 0), 1) // Keep progress between 0 and 1
                            current = total * newProgress
                        }
                )
            }
            .frame(height: barHeight)
            .padding(.horizontal, barPadding)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var current: CGFloat = 0.8
    DraggableProgressView(total: 1, current: $current)
}
