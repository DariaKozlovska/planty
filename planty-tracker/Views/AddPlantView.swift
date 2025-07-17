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
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var name: String = ""
    @State private var waterFrequency: Int = 1
    @State private var notes: String = ""
    @State private var lastWateredDate: Date = Date()
    @State private var profilePhoto: UIImage?
    
    @State private var isShowingAlert: Bool = false
    
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
                
                ScrollView {
                    VStack(spacing: 16){
                        
                        Text("Dodaj roślinę")
                            .font(.custom("Exo2-Bold", size: 28))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Nazwa rośliny", systemImage: "leaf")
                            TextField("np. Monstera", text: $name)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(12)
                        }
                        
                        HStack() {
                            Label("Podlewaj co \(waterFrequency) dni", systemImage: "drop.fill")
                            Spacer()
                            Stepper("", value: $waterFrequency, in: 1...14)
                                .labelsHidden()
                                .background(Color.white.opacity(0.3))
                                .clipShape(Capsule())
                        }
                        
                        HStack() {
                            Label("Data ostatniego podlania", systemImage: "calendar")
                            Spacer()
                            DatePicker("", selection: $lastWateredDate, displayedComponents: .date)
                                .labelsHidden()
                                .background(Color.white.opacity(0.3))
                                .clipShape(Capsule())
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            Label("Notatki", systemImage: "note.text")
                            TextEditor(text: $notes)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(12)
                                .frame(height: 100)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        
                        VStack(spacing: 8) {
                            if let image = selectedImage {
                                ZStack(alignment: .topTrailing){
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 160)
                                        .cornerRadius(12)
                                    
                                    Button(action: {
                                        selectedImage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(.lightYellow.opacity(0.5))
                                            .font(.headline)
                                            .padding()
                                    }
                                }

                            }

                            Button {
                                isShowingPhotoSourceSheet = true
                            } label: {
                                Label("Dodaj zdjęcie", systemImage: "photo")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            onSave(name, waterFrequency, notes, selectedImage, lastWateredDate, profilePhoto)
                            dismiss()
                        }) {
                            Text("Zapisz roślinę")
                                .font(.custom("Exo2-Bold", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(name.isEmpty ? .gray : themeManager.isDarkMode ? .darkTeal : .deepTeal)
                                .cornerRadius(16)
                        }
                        .disabled(name.isEmpty)
            
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { isShowingAlert = true}) {
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
            .alert("Czy na pewno chcesz anulować?", isPresented: $isShowingAlert){
                Button("Anuluj") {
                    dismiss()
                }
                Button("Zostań", role: .cancel) {}
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
    }
}

// Podgląd dla Xcode
struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView { _, _, _, _, _, _ in }
            .environmentObject(ThemeManager())
    }
}
