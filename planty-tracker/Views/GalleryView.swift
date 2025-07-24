//
//  GalleryView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 23/07/2025.
//

import SwiftUI

struct GalleryView: View {
    let plantId: UUID
    @ObservedObject var viewModel: PlantViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var plant: Plant? {
        viewModel.plants.first { $0.id == plantId }
    }

    @State private var showImagePicker: Bool = false

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        if let plant = plant {
            ZStack {
                BackgroundView()
                VStack{
                    Text("Galeria wzrostu")
                        .font(.custom("Exo2-SemiBold", size: 18))

                    Button {
                        showImagePicker = true
                    } label: {
                        Label("Dodaj dzisiejsze zdjęcie", systemImage: "photo.fill")
                            .padding()
                            .background(themeManager.isDarkMode ? Color.lightYellow.opacity(0.8) : Color.deepTeal)
                            .foregroundStyle(themeManager.isDarkMode ? Color.deepTeal : Color.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker { image in
                            viewModel.addPhotos(to: plant, image: image)
                        }
                    }

                    if !plant.photos.isEmpty {
                        GeometryReader { geometry in
                            let spacing: CGFloat = 8
                            let imageWidth = (geometry.size.width - 2 * spacing) / 3

                            ScrollView {
                                LazyVGrid(columns: columns, spacing: spacing) {
                                    ForEach(Array(plant.photos.reversed().enumerated()), id: \.element.id) { index, photo in
                                        if let image = UIImage(data: photo.imageData) {
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: imageWidth, height: imageWidth)
                                                    .clipped()
                                                    .cornerRadius(8)

                                                Button(action: {
                                                    viewModel.deletePhoto(from: plant, at: index)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white)
                                                        .background(Color.black.opacity(0.6))
                                                        .clipShape(Circle())
                                                }
                                                .padding(6)

                                                VStack {
                                                    Spacer()
                                                    Text(photo.date.formatted(date: .abbreviated, time: .omitted))
                                                        .font(.caption2)
                                                        .foregroundColor(.white)
                                                        .padding(4)
                                                        .background(Color.black.opacity(0.6))
                                                        .cornerRadius(4)
                                                        .padding(4)
                                                }
                                                .frame(width: imageWidth, height: imageWidth)
                                            }
                                        }
                                    }
                                }
                                .padding(spacing)
                            }
                        }
                        .frame(height: 300)
                    } else {
                        Text("Brak zdjęć")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
