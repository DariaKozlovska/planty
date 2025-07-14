//
//  AddPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//

import SwiftUI
import PhotosUI


extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.6)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var waterFrequency: Int = 1
    @State private var notes: String = ""
    
    @State private var isShowingPhotoSourceSheet: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var onSave: (_ name: String, _ waterFrequency: Int, _ notes: String, _ image: UIImage?) -> Void
    
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    Text("Dodaj roślinę")
                    TextField("Nazwa", text: $name)
                    Stepper("Podlewaj co \(waterFrequency) dni:", value: $waterFrequency, in: 1...7)
                    Text("Notes")
                    TextEditor(text: $notes)
                        .frame(height: 100)
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
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Dodaj"){
                        onSave(name, waterFrequency, notes, selectedImage)
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
        }
    }
}

