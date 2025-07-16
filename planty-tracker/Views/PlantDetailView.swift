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
    
    var plant: Plant?{
        viewModel.plants.first { $0.id == plantId }
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
            ScrollView{
                if let plant = plant{
                    VStack{
                        if let image = plant.profilePhoto {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                        } else {
                            Image(systemName: "leaf.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                        }
                        Text(plant.name)
                            .font(.title)
                        Text(plant.notes)
                        Text(plant.wateringFrequency.description)
                        Section(header: Text("Historia podlewiań")){
                            ForEach(Array(plant.lastWateredDates.enumerated()), id: \.element){ index, date in
                                VStack{
                                    Text(date.formatted(date: .abbreviated, time: .omitted))
                                    Button(action: {viewModel.deleteWateredDate(from: plant, at: index)}){
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.red)
                                    }
                                }
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
                        
                        Button(action: {viewModel.waterPlant(plant: plant)}){
                            Text("Podlej roślinę")
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
                }        }
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
