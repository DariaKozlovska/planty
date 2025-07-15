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
    var profilePhotoData: Data?
    var photos: [PlantPhoto]
    
    var profilePhoto: UIImage? {
        get {
            if let data = profilePhotoData {
                return UIImage(data: data)
            }
            return nil
        }
        set {
            profilePhotoData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
    
    init(id: UUID = UUID(), name: String, wateringFrequency: Int = 2, lastWateredDates: [Date] = [], notes: String = "", profilePhoto: UIImage?, photos: [PlantPhoto] = []) {
        self.id = id
        self.name = name
        self.wateringFrequency = wateringFrequency
        self.lastWateredDates = lastWateredDates
        self.notes = notes
        self.profilePhotoData = profilePhoto?.jpegData(compressionQuality: 0.8)
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
