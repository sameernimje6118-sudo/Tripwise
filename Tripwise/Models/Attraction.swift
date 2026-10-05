//
//  Attraction.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
class Attraction {

    var id: UUID
    var tripID: UUID

    var name: String
    var location: String

    var rating: Double
    var latitude: Double
    var longitude: Double

    init(
        tripID: UUID,
        name: String,
        location: String,
        rating: Double,
        latitude: Double,
        longitude: Double
    ) {
        self.id = UUID()
        self.tripID = tripID
        self.name = name
        self.location = location
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
    }
}
