//
//  AITripSummaryCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AITripSummaryCard: View {

    let summary: AISummary

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(summary.destination)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(ink)

                    Text("\(summary.days) Days • \(summary.travellers) Traveller\(summary.travellers > 1 ? "s" : "")")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 54, height: 54)

                    Image(systemName: "airplane.departure")
                        .font(.system(size: 24))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 10) {
                infoRow(icon: "location.fill", title: "Departure", value: summary.departureCity)
                infoRow(icon: "calendar", title: "Departure Date", value: summary.departureDate)
                infoRow(icon: "indianrupeesign.circle.fill", title: "Budget", value: summary.budget)
                infoRow(icon: "heart.fill", title: "Interests", value: summary.interests)
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
        HStack(alignment: .top, spacing: 10) {
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
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(stone)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AITripSummaryCard(
            summary: AISummary(
                destination: "Goa",
                departureCity: "Nagpur",
                departureDate: "12 Aug 2026",
                days: 5,
                travellers: 2,
                budget: "₹50,000",
                interests: "Beaches, Food, Nightlife"
            )
        )
        .padding()

    }

}
