//
//  RestaurantCardView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct RestaurantCardView: View {

    let restaurant: RestaurantSearchResult

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    // Food = clay everywhere else in the app (ExpensesView, ItineraryRow,
    // RestaurantsView), so this card uses the same tint rather than red.
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .top, spacing: 14) {

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(clay)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(restaurant.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(ink)
                        .lineLimit(2)

                    Label(restaurant.address, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundStyle(stone)
                        .lineLimit(2)
                }

                Spacer()
            }

            if let rating = restaurant.rating {
                Divider().overlay(Color.black.opacity(0.06))

                HStack {
                    Spacer()

                    Label(String(format: "%.1f", rating), systemImage: "star.fill")
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(clay)
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {

    RestaurantCardView(
        restaurant: RestaurantSearchResult(
            id: UUID(),
            name: "Burger King",
            address: "Goa, India",
            rating: 4.5,
            latitude: 0,
            longitude: 0
        )
    )
    .padding()
    .background(Color(red: 0.97, green: 0.95, blue: 0.92))

}
