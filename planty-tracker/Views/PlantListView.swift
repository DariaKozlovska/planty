//
//  PlantListView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct PlantListView: View {
    
    @ObservedObject var viewModel: PlantViewModel
    @State private var showAddScreen: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    var onAddPlant: (_ name: String, _ frequency: Int, _ notes: String, _ image: UIImage?, _ lastWateredDate: Date, _ profilePhoto: UIImage?) -> Void
    var onDeletePlant: (_ plant: Plant)-> Void
    var onSavePlant: (_ plant: Plant, _ newName: String) -> Void
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 16){
                    HStack(){
                        Text("Cześć!")
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
                        Button(action: {showAddScreen = true}){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.green)
                        }
                    }
                    
                    
                    ForEach(viewModel.plants){ plant in
                        NavigationLink(
                            destination:  PlantDetailView(
                                plantId: plant.id,
                                viewModel: viewModel,
                                onDeletePlant: onDeletePlant,
                                onSave: {newName in
                                    onSavePlant(plant, newName)
                                }
                            )
                            .environmentObject(themeManager)
                        ){
                            PlantCardView(plant: plant)
                        }
                    }
                }
                .padding(16)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            }
            .navigationDestination(isPresented: $showAddScreen){
                AddPlantView {name, frequency, notes, image, lastWateredDate, profilePhoto in
                    onAddPlant(name, frequency, notes, image, lastWateredDate, profilePhoto)
                    showAddScreen = false
                }
                .environmentObject(themeManager)
            }
        }
    }
}
