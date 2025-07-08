//
//  PlantListView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct PlantListView: View {
    
    let plants: [Plant]
    @State private var showAddScreen: Bool = false
    var onAddPlant: (_ name: String) -> Void
    var onDeletePlant: (_ plant: Plant) -> Void
    
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
                    
                    ForEach(plants){ plant in
                        VStack{
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(height: 120)
                                .overlay(
                                    VStack{
                                        Image(systemName: "leaf.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.green)
                                            .frame(width: 32, height: 32)
                                        Text(plant.name)
                                            .font(.headline)
                                            .padding(.top, 8)
                                        Button(action: {onDeletePlant(plant)}){
                                            Image(systemName: "trash.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.red)
                                                .frame(width:24, height:24)
                                        }
                                    }
                                )
                        }
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .background(Color.white)
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
