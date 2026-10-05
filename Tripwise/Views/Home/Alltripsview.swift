//
//  Alltripsview.swift
//  Tripwise
//
//  Created by sameer nimje on 10/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

/// Full list of trips, reached from HomeView's "See all".
struct AllTripsView: View {

    let trips: [Trip]

    @State private var searchText: String = ""

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    private var filteredTrips: [Trip] {
        guard !searchText.isEmpty else { return trips }
        return trips.filter {
            $0.destination.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            sand.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(filteredTrips) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            TripCardView(trip: trip)
                        }
                        .buttonStyle(.plain)
                    }

                    if filteredTrips.isEmpty {
                        VStack(spacing: 6) {
                            Text("No trips found")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundStyle(ink)
                            Text("Try a different destination or trip name.")
                                .font(.system(size: 13))
                                .foregroundStyle(stone)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("All Trips")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search your trips...")
    }
}

#Preview {
    NavigationStack {
        AllTripsView(trips: [])
    }
}
