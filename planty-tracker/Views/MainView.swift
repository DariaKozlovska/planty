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
        NavigationStack{
            if viewModel.plants.isEmpty {
                EmptyPlantView{
                    name in
                    viewModel.addPlant(name: name)
                }
            } else{
                PlantListView(plants: viewModel.plants, onAddPlant: {name in viewModel.addPlant(name: name)})
            }
        }
    }
}
