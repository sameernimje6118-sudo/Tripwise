//
//  SearchRestaurantsView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct SearchRestaurantsView: View {

    let trip: Trip

    @State private var restaurants: [RestaurantSearchResult] = []
    @State private var isLoading = false

    let service = RestaurantSearchService()

    var body: some View {

        ZStack {

            AppBackground()

            if isLoading {

                ProgressView("Finding Restaurants...")

            } else if restaurants.isEmpty {

                ContentUnavailableView(
                    "No Restaurants Found",
                    systemImage: "fork.knife",
                    description: Text("Try another destination.")
                )

            } else {

                ScrollView {

                    LazyVStack(spacing: 16) {

                        ForEach(restaurants) { restaurant in

                            NavigationLink {

                                RestaurantDetailView(
                                    restaurant: restaurant,
                                    trip: trip
                                )

                            } label: {

                                RestaurantCardView(
                                    restaurant: restaurant
                                )

                            }
                            .buttonStyle(.plain)

                        }

                    }
                    .padding()

                }

            }

        }
        .navigationTitle("Restaurants")
        .task {

            await loadRestaurants()

        }

    }

    // MARK: - Load

    func loadRestaurants() async {

        isLoading = true

        do {

            restaurants = try await service.searchRestaurants(
                in: trip.destination
            )

        } catch {

            print(error)

        }

        isLoading = false

    }

}

#Preview {

    NavigationStack {

        SearchRestaurantsView(
            trip: Trip(
                title: "Goa Trip",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )

    }

}
