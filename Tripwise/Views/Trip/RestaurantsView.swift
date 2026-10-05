//
//  RestaurantsView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct RestaurantsView: View {

    let trip: Trip

    @Environment(\.modelContext) private var modelContext

    @Query private var restaurants: [Restaurant]

    var tripRestaurants: [Restaurant] {
        restaurants.filter { $0.tripID == trip.id }
    }

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    // Food = clay everywhere else in the app (ExpensesView, ItineraryRow),
    // so restaurants use the same tint rather than red.
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            if tripRestaurants.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tripRestaurants) { restaurant in
                            RestaurantCard(
                                restaurant: restaurant,
                                ink: ink,
                                clay: clay,
                                stone: stone,
                                onDelete: { deleteRestaurant(restaurant) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Restaurants")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SearchRestaurantsView(trip: trip)
                } label: {
                    ZStack {
                        Circle()
                            .fill(clay)
                            .frame(width: 32, height: 32)

                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(clay.opacity(0.12))
                .frame(width: 90, height: 90)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(clay)
                }

            VStack(spacing: 6) {
                Text("No Restaurants Added")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text("Tap + to explore restaurants.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
            }

            NavigationLink {
                SearchRestaurantsView(trip: trip)
            } label: {
                Label("Browse Restaurants", systemImage: "plus.circle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(clay)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: clay.opacity(0.35), radius: 14, x: 0, y: 6)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Delete

    private func deleteRestaurant(_ restaurant: Restaurant) {
        modelContext.delete(restaurant)
        try? modelContext.save()
    }
}

// MARK: - Restaurant Card

private struct RestaurantCard: View {

    let restaurant: Restaurant
    let ink: Color
    let clay: Color
    let stone: Color
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack(spacing: 14) {

            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 56, height: 56)

                Image(systemName: "fork.knife")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(clay)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(ink)
                    .lineLimit(1)

                Label(restaurant.location, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)
                    .lineLimit(1)

                Label("\(restaurant.rating, specifier: "%.1f")", systemImage: "star.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(clay)
                    .padding(.top, 2)
            }

            Spacer()
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .contextMenu {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete Restaurant", systemImage: "trash")
            }
        }
        .confirmationDialog(
            "Remove this restaurant?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive, action: onDelete)
        } message: {
            Text("This will remove \"\(restaurant.name)\" from your trip.")
        }
    }
}

#Preview {

    NavigationStack {

        RestaurantsView(
            trip: Trip(
                title: "Goa",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
        .modelContainer(
            for: [Trip.self, Restaurant.self],
            inMemory: true
        )

    }

}
