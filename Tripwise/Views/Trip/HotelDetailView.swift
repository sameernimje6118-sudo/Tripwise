//
//  HotelDetailView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

struct HotelDetailView: View {

    let hotel: HotelSearchResult
    let trip: Trip

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    // MARK: - Body

    var body: some View {
        ZStack {
            sand.ignoresSafeArea()
            scrollContent
        }
        .navigationTitle("Hotel Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .safeAreaInset(edge: .bottom) { addToTripButton }
    }

    // MARK: - Scroll Content

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSection
                infoSection
                Divider().overlay(Color.black.opacity(0.06))
                ratingPriceSection
                Divider().overlay(Color.black.opacity(0.06))
                locationSection
                Spacer(minLength: 100)
            }
            .padding(20)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(clay.opacity(0.12))
            .frame(height: 200)
            .overlay {
                VStack(spacing: 12) {
                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 50, weight: .light))
                        .foregroundStyle(clay)

                    Text(hotel.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(ink)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .overlay(alignment: .bottomLeading) {
                if let rating = hotel.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(clay)
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(ink)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                    )
                    .padding(12)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(hotel.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(ink)

            Label(hotel.address, systemImage: "mappin.and.ellipse")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(stone)
        }
    }

    // MARK: - Rating & Price Section

    private var ratingPriceSection: some View {
        HStack(spacing: 12) {

            // Rating card
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(hotel.rating ?? 0) ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundStyle(
                                i < Int(hotel.rating ?? 0)
                                ? clay
                                : Color.black.opacity(0.15)
                            )
                    }
                }
                Text(hotel.rating != nil ? String(format: "%.1f Rating", hotel.rating!) : "No Rating")
                    .font(.system(size: 12))
                    .foregroundStyle(stone)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            }

            // Price card
           
        }
    }

    // MARK: - Location Section

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(ink)

            Text(hotel.address)
                .font(.system(size: 13))
                .foregroundStyle(stone)

            Button {
                if let url = URL(string: "https://maps.apple.com/?ll=\(hotel.latitude),\(hotel.longitude)") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label("View in Apple Maps", systemImage: "map.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(clay)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }

    // MARK: - Add To Trip Button

    private var addToTripButton: some View {
        Button {
            let newHotel = Hotel(
                tripID: trip.id,
                name: hotel.name,
                location: hotel.address,
             
                rating: hotel.rating ?? 0,
                latitude: hotel.latitude,
                longitude: hotel.longitude
            )
            modelContext.insert(newHotel)
            try? modelContext.save()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
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
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HotelDetailView(
            hotel: HotelSearchResult(
                id: UUID(),
                name: "Taj Resort Goa",
                address: "Candolim, Goa, India",
                rating: 4.7,
                
                latitude: 15.5170,
                longitude: 73.7626
            ),
            trip: Trip(
                title: "Goa Trip",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
    }
    .modelContainer(for: [Trip.self, Hotel.self], inMemory: true)
}
