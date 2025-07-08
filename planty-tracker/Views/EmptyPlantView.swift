//
//  EmptyPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct EmptyPlantView: View {
    
    @State private var isAddingPlant: Bool = false
    var onAddPlant: (_ name: String) -> Void
    
    var body: some View {
        VStack{
            Button(action: {isAddingPlant = true}){
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
            }
        }
        .sheet(isPresented: $isAddingPlant){
            AddPlantView{name in
                onAddPlant(name)
                isAddingPlant = false
            }
        }
    }
}
