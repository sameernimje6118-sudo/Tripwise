//
//  AIHotelCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIHotelCard: View {

    let hotel: AIHotel

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    /// Strips any star characters the AI response might already include
    /// (e.g. "4.8 ★"), since the row already renders its own star icon —
    /// without this, ratings like that show up as "★ 4.8 ★".
    private var cleanRating: String {
        hotel.rating
            .replacingOccurrences(of: "★", with: "")
            .replacingOccurrences(of: "⭐", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hotel")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text(hotel.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(ink)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(clay)

                        Text(cleanRating)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(stone)
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 10) {
                infoRow(icon: "mappin.and.ellipse", title: "Address", value: hotel.address)
                infoRow(icon: "indianrupeesign.circle.fill", title: "Price", value: hotel.price)
                infoRow(icon: "rectangle.and.arrow.down", title: "Check In", value: hotel.checkIn)
                infoRow(icon: "rectangle.portrait.and.arrow.right", title: "Check Out", value: hotel.checkOut)
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 8) {
                Label("Why this hotel?", systemImage: "lightbulb.fill")
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(clay)

                Text(hotel.reason)
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

        AIHotelCard(
            hotel: AIHotel(
                name: "Vivanta Goa",
                rating: "4.8 ★",
                price: "₹4,500 / night",
                address: "Candolim Beach Road, Goa",
                checkIn: "2:00 PM",
                checkOut: "11:00 AM",
                reason: "Excellent location, highly rated, close to beaches and restaurants, and fits your budget."
            )
        )
        .padding()

    }

}
