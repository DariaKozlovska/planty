//
//  PlantDetailView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 09/07/2025.
//

import SwiftUI

struct PlantDetailView: View{
    let plantId: UUID
    @ObservedObject var viewModel: PlantViewModel
    
    var onDeletePlant: (_ plant: Plant)-> Void
    var onSave: (_ name: String)-> Void
    @Environment (\.dismiss) var dismiss
    @State private var showDeleteConfirmation: Bool = false
    @State private var showEditView: Bool = false
    
    var plant: Plant?{
        viewModel.plants.first { $0.id == plantId }
    }
    
    var body: some View {
        ScrollView{
            if let plant = plant{
                VStack{
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    Text(plant.name)
                        .font(.title)
                }
                HStack (spacing: 10){
                    Button(action: {showEditView = true}){
                        Text("Edit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }){
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationDestination(isPresented: $showEditView){
            if let plant = plant {
                EditPlantView(currentName: plant.name, onSave: onSave)
            }
        }
        .alert("Czy na pewno chcesz usunąć tę plantę?", isPresented: $showDeleteConfirmation){
            Button("Nie", role: .cancel){}
            Button("Tak", role: .destructive){
                if let plant = plant{
                    onDeletePlant(plant)
                    dismiss()
                }
            }
        }
    }
}
