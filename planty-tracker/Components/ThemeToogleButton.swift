//
//  ThemeToogleButton.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 17/07/2025.
//

import SwiftUI

struct ThemeToogleButton: View{
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View{
        Button(action: {themeManager.isDarkMode.toggle()}){
            Image("FlowerIcon")
                .resizable()
                .scaledToFit()
                .padding(8)
                .background(themeManager.isDarkMode ? Color.lightYellow.opacity(0.3) :  Color.darkTeal.opacity(0.6) )
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            
        }
    }
}
