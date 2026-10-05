//
//  AITrip.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

// MARK: - Root

struct AITrip: Codable, Hashable {

    let summary: AISummary
    let flight: AIFlight
    let hotel: AIHotel
    let weather: AIWeather
    let days: [AIDay]
    let budget: AIBudget
    let tips: [String]
    let emergency: AIEmergency

}

// MARK: - Summary

struct AISummary: Codable, Hashable {

    let destination: String
    let departureCity: String
    let departureDate: String
    let days: Int
    let travellers: Int
    let budget: String
    let interests: String

}

// MARK: - Flight

struct AIFlight: Codable, Hashable {

    let airline: String
    let flightNumber: String
    let from: String
    let to: String
    let departure: String
    let arrival: String
    let duration: String
    let price: String
    let terminal: String
    let bookingAdvice: String

}

// MARK: - Hotel

struct AIHotel: Codable, Hashable {

    let name: String
    let rating: String
    let price: String
    let address: String
    let checkIn: String
    let checkOut: String
    let reason: String

}

// MARK: - Weather

struct AIWeather: Codable, Hashable {

    let condition: String
    let temperature: String
    let humidity: String
    let advice: String

}

// MARK: - Day

struct AIDay: Codable, Hashable, Identifiable {

    let day: Int
    let title: String
    let activities: [AIActivity]

    var id: Int { day }

}

// MARK: - Activity

struct AIActivity: Codable, Hashable, Identifiable {

    let time: String
    let title: String
    let type: String
    let description: String
    let duration: String
    let cost: String

    var id: String {
        "\(dayKey)-\(time)-\(title)"
    }

    private var dayKey: String {
        title
    }

}

// MARK: - Budget

struct AIBudget: Codable, Hashable {

    let flights: String
    let hotel: String
    let food: String
    let transport: String
    let activities: String
    let shopping: String
    let miscellaneous: String
    let remaining: String
    let total: String

}

// MARK: - Emergency

struct AIEmergency: Codable, Hashable {

    let police: String
    let ambulance: String
    let touristHelpline: String

}
