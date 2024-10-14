//
//  RadioToggleStyle.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/10.
//

import Foundation
import SwiftUI

struct RadioToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                .accessibilityLabel(configuration.isOn ? "checked" : "unchecked")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}
