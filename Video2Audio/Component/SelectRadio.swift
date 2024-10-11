//
//  SelectRadio.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/10.
//

import AVFoundation
import SwiftData
import SwiftUI

struct SelectRadio: View {
    @Binding var collection: [AudioResult]
    var current: AudioResult

    private let checked = (icon: "checkmark.circle.fill", text: "checked", iconColor: Color.accentColor)
    private let unChecked = (icon: "circle", text: "unchecked", iconColor: Color.secondary)

    private var isChecked: Bool {
        collection.contains(current)
    }

    var body: some View {
        let choice = isChecked ? checked : unChecked
        Button {
            toggle()
        } label: {
            Image(systemName: choice.icon)
                .foregroundStyle(choice.iconColor)
                .imageScale(.large)
        }
        .accessibility(label: Text(choice.text))
        .buttonStyle(.plain)
    }

    func toggle() {
        if isChecked {
            collection.remove(at: collection.firstIndex(of: current)!)
        } else {
            collection.append(current)
        }
    }
}
