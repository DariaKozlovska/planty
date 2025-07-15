//
//  PlantViewModel.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 08/07/2025.
//

import Foundation
import SwiftUI
import UserNotifications
import PhotosUI

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
    
    func addPlant(name: String, frequency: Int, notes: String, image: UIImage?, lastWateredDate: Date, profilePhoto: UIImage?) {
        var photos: [PlantPhoto] = []

        if let image = image {
            let photo = PlantPhoto(image: image, date: Date())
            photos.append(photo)
        }

        let newPlant = Plant(name: name, wateringFrequency: frequency, lastWateredDates: [lastWateredDate], notes: notes, profilePhoto: image, photos: photos)
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
    
    func addPhotos(to plant: Plant, image: UIImage) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            let newPhoto = PlantPhoto(image: image, date: Date())
            plants[index].photos.append(newPhoto)
        }
    }
    
    func deletePhoto(from plant: Plant, at photoIndex: Int) {
        if let plantIndex = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[plantIndex].photos.remove(at: photoIndex)
        }
    }
    
    func waterPlant(plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].lastWateredDates.insert(Date(), at: 0)
        }
    }
    
    func savePlants () {
        do {
            let encoded = try JSONEncoder().encode(plants)
            UserDefaults.standard.set(encoded, forKey: plantKey)
        } catch {
            print("Błąd zapisu roślin: \(error.localizedDescription)")
        }
    }
    
    private func loadPlants() {
        guard let savedData = UserDefaults.standard.data(forKey: plantKey) else {
            print("Brak zapisanych roślin")
            return
        }
        do {
            let decoded = try JSONDecoder().decode([Plant].self, from: savedData)
            plants = decoded
            print("Dane roślin wczytane")
        } catch {
            print("Błąd dekodowania roślin: \(error.localizedDescription)")
            UserDefaults.standard.removeObject(forKey: plantKey)
        }
    }
}
