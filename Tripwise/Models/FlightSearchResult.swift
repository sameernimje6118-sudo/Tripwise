//
//  FlightSearchResult.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct FlightSearchResult: Identifiable {

    let id = UUID()

    let airline: String
    let flightNumber: String

    let departureAirport: String
    let arrivalAirport: String

    let departureTime: Date
    let arrivalTime: Date

    let duration: String
    let price: Double

}
