//
//  AutoHeightTextEditor.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/31.
//

import SwiftUI

struct AutoHeightTextEditor: View {
    @Binding var text: String
    var body: some View {
        Text(text).foregroundColor(.clear).padding(6)
            .frame(maxWidth: .infinity)
            .overlay(
                TextEditor(text: $text)
            )
            .frame(minHeight: 20.0)
    }
}

#Preview {
    AutoHeightTextEditor(text: .constant(String(repeating: "a", count: 50)))
}
