//
//  AIFlightCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//


import SwiftUI

struct AIFlightCard: View {

    let flight: AIFlight

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Flight")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text(flight.airline)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(ink)

                    Text(flight.flightNumber)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "airplane")
                        .font(.system(size: 22))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("FROM")
                        .font(.system(size: 10.5, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(stone)

                    Text(flight.from)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(ink)

                    Text(flight.departure)
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundStyle(stone)
                }

                Spacer()

                VStack(spacing: 6) {
                    Text(flight.duration)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(stone)

                    HStack(spacing: 3) {
                        Circle().fill(clay).frame(width: 5, height: 5)
                        Rectangle().fill(clay.opacity(0.35)).frame(height: 1.5)
                        Image(systemName: "airplane")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(clay)
                        Rectangle().fill(clay.opacity(0.35)).frame(height: 1.5)
                        Circle().fill(clay).frame(width: 5, height: 5)
                    }
                    .frame(width: 90)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("TO")
                        .font(.system(size: 10.5, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(stone)

                    Text(flight.to)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(ink)

                    Text(flight.arrival)
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundStyle(stone)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 10) {
                infoRow(icon: "building.2.fill", title: "Terminal", value: flight.terminal)
                infoRow(icon: "indianrupeesign.circle.fill", title: "Price", value: flight.price)
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 8) {
                Label("Booking Advice", systemImage: "lightbulb.fill")
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(clay)

                Text(flight.bookingAdvice)
                    .font(.system(size: 12.5))
                    .foregroundStyle(stone)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 30, height: 30)

                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(clay)
            }

            Text(title)
                .font(.system(size: 13.5, weight: .medium))
                .foregroundStyle(ink)

            Spacer()

            Text(value)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
        }
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AIFlightCard(
            flight: AIFlight(
                airline: "IndiGo",
                flightNumber: "6E421",
                from: "Nagpur",
                to: "Goa",
                departure: "06:30 AM",
                arrival: "08:10 AM",
                duration: "1h 40m",
                price: "₹5,450",
                terminal: "Terminal 2",
                bookingAdvice: "Reach the airport at least 2 hours before departure."
            )
        )
        .padding()

    }

}
