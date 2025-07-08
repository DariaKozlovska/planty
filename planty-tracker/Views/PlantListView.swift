//
//  PlantListView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct PlantListView: View {
    let plants: [Plant]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16, )]){
                ForEach(plants){ plant in
                    VStack{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .frame(height: 120)
                            .overlay(
                                VStack{
                                    Image(systemName: "leaf.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(20)
                                        .foregroundColor(.green)
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
            .padding(16)
        }
    }
}
