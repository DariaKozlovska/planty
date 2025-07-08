//
//  AddPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//

import SwiftUI

struct AddPlantView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
//    @State private var waterFrequency: Int = 0
//    @State private var type: String = ""

    var onSave: (_ name: String) -> Void
    
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    Text("Dodaj roślinę")
                    TextField("Nazwa", text: $name)
                }
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Dodaj"){
                        onSave(name)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Anuluj"){
                        dismiss()
                    }
                }
            }
        }
    }
}

