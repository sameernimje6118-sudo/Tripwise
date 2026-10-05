//
//  TripwiseApp.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//

import SwiftUI
import SwiftData
import GoogleMaps
@main
struct TripwiseApp: App {
    init() {
        GMSServices.provideAPIKey("Aapi key here ")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Trip.self,
            Expense.self,
           
            Hotel.self,
            Note.self,
            Attraction.self,
            Restaurant.self,
            ItineraryItem.self,
            AIPlan.self
        ])
    }
}
