//
//  MainView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct MainView: View {
    @State private var plants: [Plant] = []
    
    var body: some View {
        NavigationView{
            if plants.isEmpty {
                EmptyPlantView()
            } else{
                Text("yours plants")
            }
        }
    }
}


#Preview {
    MainView()
}
