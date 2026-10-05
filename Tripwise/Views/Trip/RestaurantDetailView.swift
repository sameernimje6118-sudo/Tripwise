//
//  RestaurantDetailView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//


import SwiftUI
import SwiftData
import MapKit

struct RestaurantDetailView: View {

    let restaurant: RestaurantSearchResult
    let trip: Trip

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    // Food = clay everywhere else in the app (ExpensesView, ItineraryRow,
    // AddExpenseView), so this screen uses the same tint rather than red.
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Hero

                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(clay.opacity(0.12))
                        .frame(height: 200)
                        .overlay {
                            VStack(spacing: 12) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundStyle(clay)

                                Text(restaurant.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(ink)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                        )

                    // MARK: Restaurant Name

                    VStack(alignment: .leading, spacing: 8) {
                        Text(restaurant.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(ink)

                        Label(restaurant.address, systemImage: "mappin.and.ellipse")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(stone)
                    }

                    Divider().overlay(Color.black.opacity(0.06))

                    // MARK: Rating

                    HStack(spacing: 14) {
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(clay)

                            Text(restaurant.rating == nil ? "N/A" : String(format: "%.1f", restaurant.rating!))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(ink)

                            Text("Rating")
                                .font(.system(size: 11.5, weight: .medium))
                                .foregroundStyle(stone)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }

                    Divider().overlay(Color.black.opacity(0.06))

                    // MARK: Maps

                    Button {
                        if let url = URL(string: "https://maps.apple.com/?ll=\(restaurant.latitude),\(restaurant.longitude)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Open in Apple Maps", systemImage: "map.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(clay)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .navigationTitle("Restaurant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            Button {
                let newRestaurant = Restaurant(
                    tripID: trip.id,
                    name: restaurant.name,
                    location: restaurant.address,
                    rating: restaurant.rating ?? 0,
                    latitude: restaurant.latitude,
                    longitude: restaurant.longitude
                )

                modelContext.insert(newRestaurant)

                do {
                    try modelContext.save()
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } catch {
                    print("❌ Restaurant save error:", error)
                }

                dismiss()
            } label: {
                Label("Add To Trip", systemImage: "plus.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(clay)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: clay.opacity(0.35), radius: 14, x: 0, y: 6)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {

    NavigationStack {

        RestaurantDetailView(
            restaurant: RestaurantSearchResult(
                id: UUID(),
                name: "Burger King",
                address: "Goa, India",
                rating: 4.4,
                latitude: 15.5,
                longitude: 73.8
            ),
            trip: Trip(
                title: "Goa",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )

    }

}
