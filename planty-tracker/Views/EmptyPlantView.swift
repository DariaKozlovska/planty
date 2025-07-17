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
            VStack(){
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
                    VStack{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .frame(width: 280, height: 80)
                            .overlay(
                                VStack{
                                    HStack{
                                        Text("Dodaj pierwszą roślinę")
                                            .font(.custom("Exo2-Regular", size: 18))
                                            .foregroundColor(.deepTeal)
                                        Image("Plant")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .padding(0)
                                    }
                                    Spacer()
                                        .frame(height: 8)
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.deepTeal)
                                        .frame(width: 26, height: 26)
                                }
                            )
                    }
                    .cornerRadius(16)
                    .shadow(radius: 8)
                }
            }
            .toolbar{
                ToolbarItem(){
                    ThemeToogleButton()
                }
            }
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    EmptyPlantView(onAddPlant: { _, _, _, _, _, _ in })
        .environmentObject(ThemeManager())
}

