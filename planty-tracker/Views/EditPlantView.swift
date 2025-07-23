//
//  EditPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 10/07/2025.
//

import SwiftUI
import PhotosUI

struct EditPlantView: View {
    @Binding var plant: Plant
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var waterFrequency: Int
    @State private var notes: String
    @State private var lastWateredDate: Date
    @State private var profilePhoto: UIImage?

    @State private var isShowingPhotoSourceSheet: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary

    @State private var selectedImage: UIImage?

    var onSave: () -> Void

    init(plant: Binding<Plant>, onSave: @escaping () -> Void) {
        self._plant = plant
        self._name = State(initialValue: plant.wrappedValue.name)
        self._waterFrequency = State(initialValue: plant.wrappedValue.wateringFrequency)
        self._notes = State(initialValue: plant.wrappedValue.notes)
        self._lastWateredDate = State(initialValue: plant.wrappedValue.lastWateredDates.first ?? Date())
        self._profilePhoto = State(initialValue: plant.wrappedValue.profilePhoto)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        if let image = plant.profilePhoto {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)

                            Button(role: .destructive) {
                                plant.profilePhoto = nil
                            } label: {
                                Label("Usuń zdjęcie", systemImage: "trash")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        } else {
                            Image("Plant-2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .padding(12)
                                .background(Color.darkTeal.opacity(0.15))
                                .clipShape(Circle())
                        }

                        Button(action: { isShowingPhotoSourceSheet = true }) {
                            Text("Zmień zdjęcie profilowe")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.darkTeal)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 8)
                    }

                    VStack(spacing: 16) {
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
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(BackgroundView().ignoresSafeArea())

            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
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
                    }){
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34)
                            .foregroundStyle(Color.darkTeal)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }

            .confirmationDialog("Wybierz źródło zdjęcia", isPresented: $isShowingPhotoSourceSheet) {
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
            .onChange(of: selectedImage) { newImage in
                if let newImage = newImage {
                    self.plant.profilePhoto = newImage
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
    }
}
