//
//  PlantViewModel.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//

import Foundation
import SwiftUI

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = [] {
        didSet{
            savePlants()
        }
        
    }
    
    private let plantKey = "savedPlants"
    
    init() {
        loadPlants()
    }
    
    func addPlant(name: String) {
        let newPlant = Plant(name: name)
        plants.append(newPlant)
    }
    
    func deletePlant(plant: Plant){
        plants.removeAll{ $0.id == plant.id}
    }
    
    func updatePlant(plant: Plant, newName: String) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].name = newName
        }
    }

    
    private func savePlants () {
        if let encoded = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(encoded, forKey: plantKey)
        }
    }
    
    private func loadPlants () {
        if let savedData = UserDefaults.standard.data(forKey: plantKey) {
            if let decoded = try? JSONDecoder().decode([Plant].self, from: savedData) {
                plants = decoded
            }
        }
    }
}
