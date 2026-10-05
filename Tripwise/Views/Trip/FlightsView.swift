//
//  FlightsView.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

/// Flights hasn't been built yet — this is a placeholder so any tile/link
/// pointing at flights leads somewhere real instead of a broken reference.
/// Swap the body out for the actual feature whenever flight search/tracking
/// is built.
struct FlightsView: View {

    let trip: Trip

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {
        ZStack {
            sand.ignoresSafeArea()

            VStack(spacing: 20) {

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.10))
                        .frame(width: 130, height: 130)

                    Circle()
                        .fill(clay.opacity(0.14))
                        .frame(width: 96, height: 96)

                    Image(systemName: "airplane")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(clay)
                        .rotationEffect(.degrees(45))
                }

                VStack(spacing: 8) {
                    Text("COMING SOON")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1.4)
                        .foregroundStyle(clay)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(clay.opacity(0.12))
                        .clipShape(Capsule())

                    Text("Flights")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(ink)

                    Text("Track and manage flights for \(trip.destination) right from here.")
                        .font(.system(size: 13.5))
                        .foregroundStyle(stone)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 44)
                }
            }
        }
        .navigationTitle("Flights")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        FlightsView(
            trip: Trip(
                title: "Goa Vacation",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
    }
}
