//
//  EmptyPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct EmptyPlantView: View {
    
    @State private var showAddScreen: Bool = false
    var onAddPlant: (_ name: String, _ frequency: Int, _ notes: String, _ image: UIImage?) -> Void
    
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(
                    destination: AddPlantView{ name, frequency, notes, image in
                            onAddPlant(name, frequency, notes, image)
                        showAddScreen = false
                    },
                    isActive: $showAddScreen
                ){
                    EmptyView()
                }
                Button(action: {showAddScreen = true}){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            }
        }
    }
}
