//
//  model.swift
//  planty-tracker
//
//  Created by Daria Kozlovska on 07/07/2025.
//

import SwiftUI
import Foundation

struct Plant: Identifiable, Codable {
    let id : UUID
    var name : String

    var wateringFrequency: Int
    var lastWateredDates: [Date]
    var notes: String
    var photos: [PlantPhoto]
    
    init(id: UUID = UUID(), name: String, wateringFrequency: Int = 2, lastWateredDates: [Date] = [], notes: String = "", photos: [PlantPhoto] = []) {
        self.id = id
        self.name = name
        self.wateringFrequency = wateringFrequency
        self.lastWateredDates = lastWateredDates
        self.notes = notes
        self.photos = photos
    }
}


struct PlantPhoto: Identifiable, Codable {
    let id = UUID()
    let imageData: Data
    let date: Date
    
    var image: UIImage? {
        UIImage(data: imageData)
    }
    
    init(image: UIImage, date: Date) {
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        self.date = date
    }
}
