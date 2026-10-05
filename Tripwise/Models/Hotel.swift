//
//  Hotel.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Hotel {
    
    @Attribute(.unique)
    var id: UUID
    
    var tripID: UUID
    var name: String
    var location: String
    
    var rating: Double
    var latitude: Double
    var longitude: Double
    init(
        id: UUID = UUID(),
        tripID: UUID,
        name: String,
        location: String,
        
        rating: Double,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.tripID = tripID
        self.name = name
        self.location = location
       
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
    }
}
