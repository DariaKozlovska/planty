//
//  PlantViewModel.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//

import Foundation
import SwiftUI

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    
    init() {}
    
    func addPlant(name: String) {
        let newPlant = Plant(id: UUID(), name: name)
        plants.append(newPlant)
    }
    
    func deletePlant(plant: Plant){
        plants.removeAll{ $0.id == plant.id}
    }
}
