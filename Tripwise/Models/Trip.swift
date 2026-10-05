//
//  Trip.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.

import Foundation
import SwiftData

@Model
final class Trip {

    var id: UUID
    var title: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var budget: Double
    var latitude: Double
    var longitude: Double
    var aiItineraryJSON: String?
    var aiLastUpdated: Date?
    // Relationships
    var expenses: [Expense]
    var flights: [Flight]
    var hotels: [Hotel]
    var notes: [Note]
    var attractions: [Attraction]

    init(
        title: String,
        destination: String,
        startDate: Date,
        endDate: Date,
        budget: Double = 0,
        latitude: Double = 0,
        longitude: Double = 0
    ) {

        self.id = UUID()
        self.title = title
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.budget = budget
        self.latitude = latitude
        self.longitude = longitude

        self.expenses = []
        self.flights = []
        self.hotels = []
        self.notes = []
        self.attractions = []
    }
}
