//
//  AIResultView.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIResultView: View {

    let trip: AITrip

    /// Optional hook so a caller (e.g. AIPlannerView) can wire this up to
    /// regenerate in place with the same request parameters, instead of just
    /// popping back. If nil, "Regenerate Plan" simply dismisses back to the
    /// planner so the person can hit "Generate Trip" again themselves.
    var onRegenerate: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        ZStack {
            sand.ignoresSafeArea()

            ScrollView {

                LazyVStack(spacing: 20) {

                    AITripSummaryCard(summary: trip.summary)

                    AIWeatherCard(weather: trip.weather)

                    AIFlightCard(flight: trip.flight)

                    AIHotelCard(hotel: trip.hotel)

                    ForEach(trip.days) { day in
                        AIDayCard(day: day)
                    }

                    AIBudgetCard(budget: trip.budget)

                    AITravelTipsCard(tips: trip.tips)

                    AIEmergencyCard(emergency: trip.emergency)

                    actionButtons
                }
                .padding()
            }
        }
        .navigationTitle("AI Trip")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {

            Button {
                // Intentionally disabled — real import needs a mapping from
                // AITrip's string-formatted fields (e.g. "₹5,500") back into
                // the app's typed models (Trip, Hotel, Flight, Expense, etc.)
                // before this can insert anything via modelContext.
            } label: {
                Label("Import Into Trip (Coming Soon)", systemImage: "square.and.arrow.down.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(stone.opacity(0.15))
                    .foregroundStyle(stone)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(true)

            NavigationLink {

                AIPlannerView()

            } label: {

                Label(
                    "Regenerate Plan",
                    systemImage: "sparkles"
                )
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(clay)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            }
        }
    }
}

#Preview {

    NavigationStack {

        AIResultView(
            trip: AITrip(
                summary: AISummary(
                    destination: "Goa",
                    departureCity: "Nagpur",
                    departureDate: "12 Aug 2026",
                    days: 5,
                    travellers: 2,
                    budget: "₹50,000",
                    interests: "Beach, Food"
                ),
                flight: AIFlight(
                    airline: "IndiGo",
                    flightNumber: "6E421",
                    from: "Nagpur",
                    to: "Goa",
                    departure: "06:30",
                    arrival: "08:00",
                    duration: "1h 30m",
                    price: "₹5,500",
                    terminal: "T2",
                    bookingAdvice: "Reach airport 2 hours early"
                ),
                hotel: AIHotel(
                    name: "Vivanta Goa",
                    rating: "4.7",
                    price: "₹4,500/night",
                    address: "Candolim, Goa",
                    checkIn: "2 PM",
                    checkOut: "11 AM",
                    reason: "Close to beaches"
                ),
                weather: AIWeather(
                    condition: "Sunny",
                    temperature: "30°C",
                    humidity: "72%",
                    advice: "Carry sunscreen"
                ),
                days: [],
                budget: AIBudget(
                    flights: "₹5,500",
                    hotel: "₹18,000",
                    food: "₹6,000",
                    transport: "₹3,000",
                    activities: "₹4,000",
                    shopping: "₹2,000",
                    miscellaneous: "₹1,500",
                    remaining: "₹10,000",
                    total: "₹40,000"
                ),
                tips: [
                    "Carry sunscreen",
                    "Book attractions early"
                ],
                emergency: AIEmergency(
                    police: "100",
                    ambulance: "108",
                    touristHelpline: "1363"
                )
            )
        )

    }

}
