//
//  AddPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//


import SwiftUI
import PhotosUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var waterFrequency: Int = 1
    @State private var notes: String = ""
    @State private var lastWateredDate: Date = Date()
    @State private var profilePhoto: UIImage?
    
    @State private var isShowingPhotoSourceSheet: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var onSave: (_ name: String, _ waterFrequency: Int, _ notes: String, _ image: UIImage?, _ lastWateredDate: Date, _ profilePhoto: UIImage?) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                Form {
                    VStack{
                        Text("Dodaj roślinę")
                        TextField("Nazwa", text: $name)
                        Stepper("Podlewaj co \(waterFrequency) dni:", value: $waterFrequency, in: 1...7)
                        Text("Notes")
                        TextEditor(text: $notes)
                            .frame(height: 100)
                        DatePicker("Data ostatniego polewu", selection: $lastWateredDate, displayedComponents: .date)
                    }
                    Section{
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame( height: 150)
                        }
                        Button("Dodaj zdjęcie"){
                            isShowingPhotoSourceSheet = true
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .padding(.horizontal, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") {
                        onSave(name, waterFrequency, notes, selectedImage, lastWateredDate, profilePhoto)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {dismiss()}) {
                        Text("Anuluj")
                    }
                }
            }
            .confirmationDialog("Wybierz źródło zdjęcia",
                                isPresented: $isShowingPhotoSourceSheet) {
                Button("Zrób zdjęcie") {
                    imageSource = .camera
                    isShowingImagePicker = true
                }
                
                Button("Wybierz z galerii") {
                    imageSource = .photoLibrary
                    isShowingImagePicker = true
                }
                
                Button("Anuluj", role: .cancel) {}
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: imageSource) { image in
                    selectedImage = image
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
    }
}

// Podgląd dla Xcode
//struct AddPlantView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlantView { _, _, _, _, _, _ in }
//    }
//}
