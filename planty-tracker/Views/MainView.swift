//
//  MainView.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = PlantViewModel()
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        NavigationStack{
            ZStack{
                BackgroundView()
                    .environmentObject(themeManager)
                if viewModel.plants.isEmpty {
                    EmptyPlantView{
                        name, frequency, notes, image, lastWateredDate, profilePhoto in
                        viewModel.addPlant(name: name, frequency: frequency, notes: notes, image: image, lastWateredDate: lastWateredDate, profilePhoto: profilePhoto)
                    }
                    .environmentObject(themeManager)
                } else{
                    PlantListView(viewModel: viewModel,
                                  onAddPlant: {name, frequency, notes, image, lastWateredDate, profilePhoto in
                        viewModel.addPlant(name: name, frequency: frequency, notes: notes, image: image, lastWateredDate: lastWateredDate, profilePhoto: profilePhoto)},
                                  onDeletePlant: {plant in viewModel.deletePlant(plant: plant)},
                                  onSavePlant: { plant, newName in
                        viewModel.updatePlant(plant: plant, newName: newName)
                    }
                    )
                    .environmentObject(themeManager)
                }
            }
        }
    }
}
