//
//  PlantDetailView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 09/07/2025.
//

import SwiftUI

struct PlantDetailView: View{
    @State var plant: Plant
    var onDeletePlant: (_ plant: Plant)-> Void
    @Environment (\.dismiss) var dismiss
    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        ScrollView{
            VStack{
                Image(systemName: "leaf.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                Text(plant.name)
                    .font(.title)
            }
            HStack (spacing: 10){
                Button(action: {}){
                    Text("Edit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
//                    onDeletePlant(plant)
//                    dismiss()
                    showDeleteConfirmation = true
                }){
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .alert("Czy na pewno chcesz usunąć tę plantę?", isPresented: $showDeleteConfirmation){
            Button("Nie", role: .cancel){}
            Button("Tak", role: .destructive){
                onDeletePlant(plant)
                dismiss()
            }
        }
    }
}
