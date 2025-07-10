//
//  EditPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 10/07/2025.
//

import SwiftUI

struct EditPlantView: View{
    @Environment (\.dismiss) var dismiss
    @State private var name: String
    var onSave: (_ name: String) -> Void
    
    init(currentName: String, onSave: @escaping (_ name: String) -> Void){
        self._name = State(initialValue: currentName)
        self.onSave = onSave
    }
    
    var body: some View{
        NavigationView{
            Form{
                VStack{
                    Text("Edytuj nazwę")
                    TextField("Nazwa", text: $name)
                }
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Zapisz"){
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
