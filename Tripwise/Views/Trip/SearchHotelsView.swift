//
//  HotelSearchTestView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData
import SwiftUI
import SwiftData

struct SearchHotelsView: View {

    let trip: Trip

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var hotels: [HotelSearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    let service = HotelSearchService()

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {
        ZStack {
            sand.ignoresSafeArea()

            if isLoading {
                loadingState
            } else if errorMessage != nil {
                errorState
            } else if hotels.isEmpty {
                emptyState
            } else {
                hotelList
            }
        }
        .navigationTitle(trip.destination)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .task {
            await fetchHotels()
        }
    }

    // MARK: - Hotel List

    private var hotelList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {

                ForEach(hotels) { hotel in
                    NavigationLink {
                        HotelDetailView(
                            hotel: hotel,
                            trip: trip
                        )
                    } label: {
                        HotelCardView(hotel: hotel, trip: trip)
                    }
                }

            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .refreshable {
            await fetchHotels()
        }
    }

    // MARK: - Loading State

    private var loadingState: some View {
        VStack(spacing: 16) {

            ProgressView()
                .scaleEffect(1.2)
                .tint(clay)

            Text("Finding hotels...")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(stone)

        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {

            Circle()
                .fill(clay.opacity(0.12))
                .frame(width: 90, height: 90)
                .overlay {

                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(clay)

                }

            VStack(spacing: 6) {
                Text("No Hotels Found")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text("Couldn't find hotels in \(trip.destination).")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Error State

    private var errorState: some View {
        VStack(spacing: 16) {

            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 90, height: 90)
                .overlay {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 34, weight: .light))
                        .foregroundStyle(.red.opacity(0.85))
                }

            VStack(spacing: 6) {
                Text("Something Went Wrong")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text(errorMessage ?? "Please check your connection and try again.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button {
                Task { await fetchHotels() }
            } label: {
                Text("Try Again")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 11)
                    .background(clay)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Fetch Hotels

    @MainActor
    private func fetchHotels() async {

        isLoading = true
        errorMessage = nil

        do {
            hotels = try await service.searchHotels(in: trip.destination)
        } catch {
            errorMessage = "We couldn't reach the hotel search service. Please try again."
            print("❌ Hotel search error:", error)
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        SearchHotelsView(
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
