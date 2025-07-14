//
//  PlantCardView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 10/07/2025.
//

import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(height: 120)
                .overlay(
                    VStack{
                        if let image = plant.photos.first?.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        } else {
                            Image(systemName: "leaf.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 32, height: 32)
                        }
                        Text(plant.name)
                            .font(.headline)
                            .padding(.top, 8)
                    }
                )
        }
        .cornerRadius(16)
        .shadow(radius: 8)
        .background(Color.white)
    }
}
