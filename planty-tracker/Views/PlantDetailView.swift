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
    @State private var showImagePicker: Bool = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var plant: Plant?{
        viewModel.plants.first { $0.id == plantId }
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
            ScrollView{
                if let plant = plant{
                    VStack{
                        
                        Group {
                            if let image = plant.profilePhoto {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            } else {
                                Image("Plant-2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .padding(12)
                                    .background(Color.darkTeal.opacity(0.15))
                                    .clipShape(Circle())
                            }
                        }
                        
                        VStack(spacing: 4){
                            Text(plant.name)
                                .font(.custom("Exo2-SemiBold", size: 28))
                                
                            Text("Częstotliwość polewu: co \(plant.wateringFrequency.description) dni")
                            
                            WaterCalendar(plant: plant, viewModel: viewModel)
                                .padding()
                            
                        }

                        
                        VStack{
                            if !plant.notes.isEmpty {
                                Text(plant.notes)
                                    .multilineTextAlignment(.center)
                                    .background(.thinMaterial)
                            }
                        }
                        
                        ScrollView{
                            HStack{
                                ForEach(Array(plant.photos.enumerated()), id: \.element.id){ index, photo in
                                    if let image = UIImage(data: photo.imageData){
                                        VStack{
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 180, height: 180)
                                            Button(action: {viewModel.deletePhoto(from: plant, at: index)}){
                                                Image(systemName: "cross.circle")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
                        
                        Button(action: {showImagePicker = true}){
                            Text("dodaj zdjęcie")
                        }
                        .sheet(isPresented: $showImagePicker){
                            ImagePicker{ image in
                                viewModel.addPhotos(to: plant, image: image)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationDestination(isPresented: $showEditView){
                if let index = viewModel.plants.firstIndex(where: { $0.id == plant?.id }),
                   let plant = plant {
                    EditPlantView(plant: $viewModel.plants[index]) {
                        viewModel.savePlants()
                    }
                    .environmentObject(themeManager)
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
}
