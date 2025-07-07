//
//  EmptyPlantView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct EmptyPlantView: View {
    var body: some View {
        VStack{
            Button(action: {}){
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    EmptyPlantView()
}
