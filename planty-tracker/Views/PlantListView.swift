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
    var onAddPlant: (_ name: String) -> Void
    var onDeletePlant: (_ plant: Plant)-> Void
    var onSavePlant: (_ plant: Plant, _ newName: String) -> Void
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 16){
                    HStack(){
                        Text("Cześć!")
                        Spacer()
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
                        ){
                            PlantCardView(plant: plant)
                        }
                    }
                }
                .padding(16)
            }
            .navigationDestination(isPresented: $showAddScreen){
                AddPlantView {newPlantName in
                    onAddPlant(newPlantName)
                    showAddScreen = false
                }
            }
        }
    }
}
