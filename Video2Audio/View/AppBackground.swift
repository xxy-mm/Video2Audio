//
//  AppBackground.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/29.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            Image("app-bg")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: .infinity)
                .ignoresSafeArea()
            Color.blue.opacity(0.3)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AppBackground()
}
