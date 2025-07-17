//
//  planty_trackerApp.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

@main
struct planty_trackerApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(themeManager)
                .environment(\.font, .custom("Exo2-Regular", size: 16))
        }
    }
}
