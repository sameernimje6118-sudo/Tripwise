//
//  GeminiService.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

final class GeminiService {

    // Replace with your Gemini API Key
    private let apiKey = "api key here"

    private var endpoint: URL {
        URL(string:
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"
        )!
    }

    func generateTrip(
        destination: String,
        departureCity: String,
        departureDate: Date,
        days: Int,
        travellers: Int,
        budget: Double,
        interests: String
    ) async throws -> AITrip {

        let prompt = """
        You are TripWise AI, an expert travel planner.

        Return ONLY valid JSON.

        Do NOT use markdown.
        Do NOT use code blocks.
        Do NOT explain anything.
        Do NOT add extra text.

        Every field must contain a value.

        Stay within the user's budget.

        ----------------------------------------

        Transportation Rules

        The "flight" object represents the recommended transportation.

        It may be:

        • Flight
        • Train
        • Bus
        • Taxi / Cab

        Always choose the most practical option.

        Priority:

        1. Flight
        2. Train
        3. Bus
        4. Taxi

        Rules

        • If flights are available and fit within the user's budget, recommend a flight.
        • If flights are unavailable or too expensive, recommend a train.
        • If trains are unavailable, recommend a bus.
        • If the destination is nearby (approximately 250 km or less), recommend a taxi or self-drive.
        • Never recommend a transport option that exceeds the user's total budget.

        Generate REALISTIC transportation details.

        For Flights provide:
        - Airline
        - Flight Number
        - Departure Airport
        - Arrival Airport
        - Departure Time
        - Arrival Time
        - Duration
        - Terminal
        - Cabin Class
        - Baggage Allowance
        - Ticket Price (per person)
        - Total Price
        - Booking Advice

        For Trains provide:
        - Train Name
        - Train Number
        - Departure Station
        - Arrival Station
        - Departure Time
        - Arrival Time
        - Duration
        - Coach Class
        - Seat Availability (estimated)
        - Ticket Price (per person)
        - Total Price
        - Platform (estimated)
        - Booking Advice

        For Buses provide:
        - Bus Operator
        - Bus Type (Sleeper/Volvo/AC etc.)
        - Bus Number
        - Boarding Point
        - Dropping Point
        - Departure Time
        - Arrival Time
        - Duration
        - Ticket Price (per person)
        - Total Price
        - Boarding Instructions

        For Taxi provide:
        - Cab Provider
        - Vehicle Type
        - Estimated Distance
        - Estimated Driving Time
        - Pickup Location
        - Drop Location
        - Estimated Fare
        - Toll Charges (if any)
        - Fuel Cost (if self-drive)
        - Booking Advice

        Use the existing JSON fields like this:

        airline =
        Flight Airline / Train Name / Bus Operator / Cab Provider

        flightNumber =
        Flight Number / Train Number / Bus Number / Vehicle Type

        terminal =
        Terminal / Platform / Boarding Point / Pickup Location

        bookingAdvice =
        All travel instructions for the selected transport.

        price =
        Total transportation cost for all travellers.
        ----------------------------------------

        Return exactly this JSON:

        {
          "summary":{
            "destination":"",
            "departureCity":"",
            "departureDate":"",
            "days":0,
            "travellers":0,
            "budget":"",
            "interests":""
          },

          "flight":{
            "airline":"",
            "flightNumber":"",
            "from":"",
            "to":"",
            "departure":"",
            "arrival":"",
            "duration":"",
            "price":"",
            "terminal":"",
            "bookingAdvice":""
          },

          "hotel":{
            "name":"",
            "rating":"",
            "price":"",
            "address":"",
            "checkIn":"",
            "checkOut":"",
            "reason":""
          },

          "weather":{
            "condition":"",
            "temperature":"",
            "humidity":"",
            "advice":""
          },

          "days":[
            {
              "day":1,
              "title":"",
              "activities":[
                {
                  "time":"",
                  "title":"",
                  "type":"",
                  "description":"",
                  "duration":"",
                  "cost":""
                }
              ]
            }
          ],

          "budget":{
            "flights":"",
            "hotel":"",
            "food":"",
            "transport":"",
            "activities":"",
            "shopping":"",
            "miscellaneous":"",
            "remaining":"",
            "total":""
          },

          "tips":[
            ""
          ],

          "emergency":{
            "police":"",
            "ambulance":"",
            "touristHelpline":""
          }
        }

        Generate a realistic trip.

        Destination:
        \(destination)

        Departure City:
        \(departureCity)

        Departure Date:
        \(departureDate.formatted(date: .abbreviated, time: .omitted))

        Days:
        \(days)

        Travellers:
        \(travellers)

        Budget:
        ₹\(Int(budget))

        Interests:
        \(interests)

        Planning Rules

        • Stay inside the user's budget.
        • Recommend the best transportation.
        • Prefer flights.
        • If flights exceed the budget, automatically switch to train.
        • If trains are unavailable, switch to bus.
        • If the destination is nearby, recommend taxi.
        • Recommend a hotel near attractions.
        • Adjust activities according to weather.
        • Include realistic timings.
        • Include realistic prices.
        • Include local transport.
        • Include food recommendations.
        • Finish every day at the hotel unless overnight travel is required.

        Return ONLY valid JSON.
        """

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": prompt
                        ]
                    ]
                ]
            ]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)

        let response = try JSONDecoder().decode(
            GeminiResponse.self,
            from: data
        )

        guard let text =
            response
                .candidates
                .first?
                .content
                .parts
                .first?
                .text
        else {
            throw URLError(.badServerResponse)
        }

        guard let json = text.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }

        return try JSONDecoder().decode(
            AITrip.self,
            from: json
        )

    }

}

// MARK: - Gemini Response

private struct GeminiResponse: Codable {

    let candidates: [Candidate]

}

private struct Candidate: Codable {

    let content: Content

}

private struct Content: Codable {

    let parts: [Part]

}

private struct Part: Codable {

    let text: String

}
