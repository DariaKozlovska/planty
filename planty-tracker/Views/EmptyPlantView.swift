//
//  EmptyPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct EmptyPlantView: View {
    
    @State private var showAddScreen: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    var onAddPlant: (_ name: String, _ frequency: Int, _ notes: String, _ image: UIImage?, _ lastedWateredDate: Date, _ profilePhoto: UIImage?) -> Void
    
    var body: some View {
        NavigationStack{
            VStack{
                LazyHStack{
                    Spacer()
                    Button(action: {
                        themeManager.isDarkMode.toggle()
                    }) {
                        Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                }
                
                NavigationLink(
                    destination: AddPlantView{ name, frequency, notes, image, lastWateredDate, profilePhoto in
                            onAddPlant(name, frequency, notes, image, lastWateredDate, profilePhoto)
                        showAddScreen = false
                    }
                    .environmentObject(themeManager),
                    isActive: $showAddScreen
                ){
                    EmptyView()
                }
                Button(action: {showAddScreen = true}){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            }
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
