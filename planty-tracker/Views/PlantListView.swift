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
                            .font(.custom("Exo2-SemiBold", size: 20))
                        Spacer()
                        ThemeToogleButton()
                        Button(action: {showAddScreen = true}){
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(themeManager.isDarkMode ? .lightYellow.opacity(0.8) :  .darkTeal)
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
                            PlantCard(plant: plant)
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
