//
//  PlantCardView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 10/07/2025.
//

import SwiftUI

struct PlantCard: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 12) {
            Group{
                if let image = plant.profilePhoto {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .shadow(radius: 4)
                } else {
                    Image("Plant-2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(12)
                        .background(Color.darkTeal.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.20)

            VStack(alignment: .leading){
                Text(plant.name)
                    .font(.custom("Exo2-SemiBold", size: 18))
                    .foregroundColor(.blackTeal)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                if let last = plant.lastWateredDates.sorted().last {
                    WaterProgressBar(lastWatered: last, frequency: plant.wateringFrequency)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(UIColor.secondarySystemBackground))
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
//        .padding(.horizontal, 8)
    }
}
