//
//  MainView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = PlantViewModel()

    var body: some View {
        NavigationView{
            if viewModel.plants.isEmpty {
                EmptyPlantView{
                    name in
                    let newPlant = Plant(id: UUID(), name: name)
                    viewModel.plants.append(newPlant)
                }
            } else{
                PlantListView(plants: viewModel.plants)
            }
        }
    }
}


#Preview {
    MainView()
}
