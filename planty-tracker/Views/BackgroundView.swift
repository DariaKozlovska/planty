//
//  Backgrounds.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 16/07/2025.
//

import SwiftUI

struct BackgroundView: View {
//    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Group{
            if themeManager.isDarkMode {
                LinearGradient(
                    gradient: Gradient(colors: [.darkTeal, .deepTeal, .blackTeal]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [.lightYellow, .darkTeal]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
//        Image("Background")
//            .resizable()
//            .scaledToFill()
//            .ignoresSafeArea()
//            .frame(minWidth: 0, maxWidth: .infinity)

    }
}

#Preview {
    BackgroundView()
}
