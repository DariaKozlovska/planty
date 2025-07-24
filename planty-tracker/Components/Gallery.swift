//
//  Gallery.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 23/07/2025.
//

import SwiftUI

struct Gallery: View {
    let plantId: UUID
    @ObservedObject var viewModel: PlantViewModel

    var plant: Plant? {
        viewModel.plants.first { $0.id == plantId }
    }

    var body: some View {
        if let plant = plant, !plant.photos.isEmpty {
            GeometryReader { geometry in
                let spacing: CGFloat = 8
                let imageWidth = (geometry.size.width - 2 * spacing) / 3

                HStack(spacing: spacing) {
                    ForEach(Array(plant.photos.suffix(3).reversed().enumerated()), id: \.element.id) { index, photo in
                        if let image = UIImage(data: photo.imageData) {
                            ZStack(alignment: .bottom) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageWidth)
                                    .clipped()
                                    .cornerRadius(8)

                                Text(photo.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
            .frame(height: 120)
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
}
