//
//  Flight.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Flight {

    @Attribute(.unique)
    var id: UUID

    var tripID: UUID

    var airline: String
    var flightNumber: String

    var departureAirport: String
    var arrivalAirport: String

    var departureTime: Date
    var arrivalTime: Date

    var duration: String
    var price: Double

    var bookingURL: String

    init(
        id: UUID = UUID(),
        tripID: UUID,
        airline: String,
        flightNumber: String,
        departureAirport: String,
        arrivalAirport: String,
        departureTime: Date,
        arrivalTime: Date,
        duration: String,
        price: Double,
        bookingURL: String
    ) {
        self.id = id
        self.tripID = tripID
        self.airline = airline
        self.flightNumber = flightNumber
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.price = price
        self.bookingURL = bookingURL
    }
}
