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
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if !plant.notes.isEmpty {
                                Text("Twoja notatka")
                                    .font(.custom("Exo2-SemiBold", size: 18))
                                    .padding(.top)
                                    .frame(maxWidth: .infinity, alignment: .center)

                                ScrollView {
                                    Text(plant.notes)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: 300)
                        .background(.white.opacity(0.14))
                        .cornerRadius(12)
                        .padding()
                        
                        VStack{
                            Text("Galeria wzrostu")
                                .font(.custom("Exo2-SemiBold", size: 18))
                            Gallery(plantId: plantId, viewModel: viewModel)
                            HStack{
                                Button(action: {showImagePicker = true}){
                                    HStack{
                                        Text("Dodaj zdjęcie")
                                        Image(systemName: "photo.fill")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(themeManager.isDarkMode ? Color.lightYellow.opacity(0.8) :  Color.deepTeal)
                                    .foregroundStyle(themeManager.isDarkMode ? Color.deepTeal : Color.white)
                                    .cornerRadius(10)
                                        
                                }
                                .sheet(isPresented: $showImagePicker){
                                    ImagePicker{ image in
                                        viewModel.addPhotos(to: plant, image: image)
                                    }
                                }
                                Button (action: {}){
                                    HStack{
                                        Text("Zobacz galerię")
                                        Image(systemName: "arrow.right")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(themeManager.isDarkMode ? Color.lightYellow.opacity(0.8) :  Color.deepTeal)
                                    .foregroundStyle(themeManager.isDarkMode ? Color.deepTeal : Color.white)
                                    .cornerRadius(10)
                                }
                                
                            }

                        }
                        .padding()
                    }
                    
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
            .navigationBarItems(trailing: HStack {
                Button(action: {showEditView = true}){
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .foregroundStyle(themeManager.isDarkMode ? Color.lightYellow.opacity(0.8) :  Color.deepTeal)
                }
                
                Button(action: {
                    showDeleteConfirmation = true
                }){
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .foregroundStyle(themeManager.isDarkMode ? Color.red : Color.red.opacity(0.7))
                }
            })
            
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
