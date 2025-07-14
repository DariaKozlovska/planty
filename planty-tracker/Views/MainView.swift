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
                    name, frequency, notes, image in
                    viewModel.addPlant(name: name, frequency: frequency, notes: notes, image: image)
                }
            } else{
                PlantListView(viewModel: viewModel,
                              onAddPlant: {name, frequency, notes, image in
                    viewModel.addPlant(name: name, frequency: frequency, notes: notes, image: image)},
                              onDeletePlant: {plant in viewModel.deletePlant(plant: plant)},
                              onSavePlant: { plant, newName in
                                  viewModel.updatePlant(plant: plant, newName: newName)
                              }
                )
            }
        }
    }
}
