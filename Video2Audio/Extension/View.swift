//
//  View.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/11.
//


import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        }else {
            self
        }
    }
}
