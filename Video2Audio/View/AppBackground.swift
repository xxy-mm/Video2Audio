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
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height)
                .clipped()
                .ignoresSafeArea()
                .blur(radius: 10)
            Color.blue.opacity(0.3)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    AppBackground()
}
