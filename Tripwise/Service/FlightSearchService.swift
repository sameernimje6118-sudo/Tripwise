//
//  FlightSearchService.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct FlightSearchService {

    func searchFlights(
        from: String,
        to: String,
        date: Date
    ) async throws -> [FlightSearchResult] {

        return [

            FlightSearchResult(
                airline: "IndiGo",
                flightNumber: "6E-521",
                departureAirport: from,
                arrivalAirport: to,
                departureTime: date.addingTimeInterval(9 * 3600),
                arrivalTime: date.addingTimeInterval(10.5 * 3600),
                duration: "1h 30m",
                price: 5450
            ),

            FlightSearchResult(
                airline: "Air India",
                flightNumber: "AI-684",
                departureAirport: from,
                arrivalAirport: to,
                departureTime: date.addingTimeInterval(12 * 3600),
                arrivalTime: date.addingTimeInterval(13.5 * 3600),
                duration: "1h 30m",
                price: 5980
            ),

            FlightSearchResult(
                airline: "Akasa Air",
                flightNumber: "QP-1472",
                departureAirport: from,
                arrivalAirport: to,
                departureTime: date.addingTimeInterval(17 * 3600),
                arrivalTime: date.addingTimeInterval(18.5 * 3600),
                duration: "1h 30m",
                price: 5200
            )
]
        }

    }


