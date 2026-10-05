//
//  SearchAttractionsView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct SearchAttractionsView: View {

    let trip: Trip

    @State private var attractions: [AttractionSearchResult] = []
    @State private var isLoading = false

    let service = AttractionSearchService()

    var body: some View {

        ZStack {

            AppBackground()

            if isLoading {

                ProgressView("Finding Attractions...")

            } else if attractions.isEmpty {

                ContentUnavailableView(
                    "No Attractions Found",
                    systemImage: "mappin.and.ellipse",
                    description: Text("Try another destination.")
                )

            } else {

                ScrollView {

                    LazyVStack(spacing: 16) {

                        ForEach(attractions) { attraction in

                            NavigationLink {

                                AttractionDetailView(
                                    attraction: attraction,
                                    trip: trip
                                )

                            } label: {

                                AttractionCardView(
                                    attraction: attraction
                                )

                            }
                            .buttonStyle(.plain)

                        }

                    }
                    .padding()

                }

            }

        }
        .navigationTitle("Attractions")
        .task {

            await loadAttractions()

        }

    }

    // MARK: - Load

    func loadAttractions() async {

        isLoading = true

        do {

            attractions = try await service.searchAttractions(
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

        SearchAttractionsView(
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
