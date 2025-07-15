//
//  EditPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 10/07/2025.
//

import SwiftUI
import PhotosUI

struct EditPlantView: View{
    @Binding var plant: Plant
    @Environment (\.dismiss) var dismiss

    @State private var name: String
    @State private var waterFrequency: Int = 1
    @State private var notes: String = ""
    @State private var lastWateredDate: Date = Date()
    @State private var profilePhoto: UIImage?
    
    @State private var isShowingPhotoSourceSheet: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedImage: UIImage?
    
    var onSave: () -> Void
    
    init(plant: Binding<Plant>, onSave: @escaping () -> Void){
        self._plant = plant
        self._name = State(initialValue: plant.wrappedValue.name)
        self._waterFrequency = State(initialValue: plant.wrappedValue.wateringFrequency)
        self._notes = State(initialValue: plant.wrappedValue.notes)
        self._lastWateredDate = State(initialValue: plant.wrappedValue.lastWateredDates.first ?? Date())
        self._profilePhoto = State(initialValue: plant.wrappedValue.profilePhoto)
        self.onSave = onSave
    }
    
    var body: some View{
        NavigationView{
            Form{
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
                    Button(action: {isShowingPhotoSourceSheet = true}){
                        Text("Zmień zdjęcie profilowe")
                    }
                    Text("Edytuj nazwę")
                    TextField("Nazwa", text: $name)
                    Stepper("Podlewaj co \(waterFrequency) dni:", value: $waterFrequency, in: 1...7)
                    Text("Notes")
                    TextEditor(text: $notes)
                        .frame(height: 100)
                    DatePicker("Data ostatniego polewu", selection: $lastWateredDate, displayedComponents: .date)
                }
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Zapisz"){
                        plant.name = name
                        plant.wateringFrequency = waterFrequency
                        plant.notes = notes

                        if plant.lastWateredDates.isEmpty {
                            plant.lastWateredDates.append(lastWateredDate)
                        } else {
                            plant.lastWateredDates[0] = lastWateredDate
                        }
                        
                        onSave()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Anuluj"){
                        dismiss()
                    }
                }
            }
            .confirmationDialog("Wybierz źródło zdjęcia", isPresented: $isShowingPhotoSourceSheet){
                Button("Zrób zdjęcie"){
                    imageSource = .camera
                    isShowingImagePicker = true
                }
                Button("Wybierz zdjęcie z galerii"){
                    imageSource = .photoLibrary
                    isShowingImagePicker = true
                }
                Button("Anuluj", role: .cancel){}
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: imageSource) { image in
                    selectedImage = image
                }
            }
            .onChange(of: selectedImage) { newImage in
                if let newImage = newImage {
                    self.plant.profilePhoto = newImage
                }
            }
        }
    }
}
