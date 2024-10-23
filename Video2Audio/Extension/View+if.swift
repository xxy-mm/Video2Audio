//
//  View.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/11.
//


import SwiftUI

extension View {
    /// show the view when condiftion is true, otherwise remove the view
    @ViewBuilder func `if`(_ condition: @autoclosure () -> Bool) -> some View {
        if condition() {
            self
        }else {
            EmptyView()
        }
    }
    /// transform the view if the condition is true, otherwise keep the view unchanged
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        }else {
            self
        }
    }
    
    
}
