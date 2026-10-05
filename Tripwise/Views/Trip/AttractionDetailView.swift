//
//  AttractionDetailView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

struct AttractionDetailView: View {

    let attraction: AttractionSearchResult
    let trip: Trip

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        ZStack {
            AppBackground()
            scrollContent
        }
        .navigationTitle("Attraction")
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
                Divider().opacity(0.4)
                ratingSection
                Divider().opacity(0.4)
                locationSection
                Spacer(minLength: 100)
            }
            .padding(20)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color(red: 0.92, green: 0.98, blue: 0.92))
            .frame(height: 200)
            .overlay {
                VStack(spacing: 12) {
                    Image(systemName: "camera.metering.center.weighted")
                        .font(.system(size: 56))
                        .foregroundStyle(Color(red: 0.20, green: 0.70, blue: 0.35))

                    Text(attraction.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .overlay(alignment: .bottomLeading) {
                if let rating = attraction.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.9))
                    .clipShape(Capsule())
                    .padding(12)
                }
            }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(attraction.name)
                .font(.title2)
                .fontWeight(.bold)

            Label(attraction.address, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Rating Section

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rating")
                .font(.title3)
                .fontWeight(.semibold)

            if let rating = attraction.rating {
                HStack(spacing: 12) {

                    HStack(spacing: 4) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < Int(rating) ? "star.fill" : "star")
                                .font(.system(size: 18))
                                .foregroundStyle(
                                    i < Int(rating)
                                    ? Color(red: 1.0, green: 0.42, blue: 0.21)
                                    : Color.gray.opacity(0.3)
                                )
                        }
                    }

                    Text(String(format: "%.1f", rating))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                }

            } else {
                Text("No rating available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Location Section

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.title3)
                .fontWeight(.semibold)

            Text(attraction.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                let url = URL(
                    string: "http://maps.apple.com/?ll=\(attraction.latitude),\(attraction.longitude)"
                )!
                UIApplication.shared.open(url)
            } label: {
                Label("Open in Apple Maps", systemImage: "map.fill")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.21, green: 0.66, blue: 1.0))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    // MARK: - Add To Trip Button

    private var addToTripButton: some View {
        Button {

            let newAttraction = Attraction(
                tripID: trip.id,
                name: attraction.name,
                location: attraction.address,
                rating: attraction.rating ?? 0,
                latitude: attraction.latitude,
                longitude: attraction.longitude
            )

            modelContext.insert(newAttraction)

            print("Saved tripID:", newAttraction.tripID)
            print("Current tripID:", trip.id)

            do {
                try modelContext.save()
                print("Saved successfully")
            } catch {
                print("❌ Save Error:", error)
            }

            dismiss()

        } label: {
            Label("Add To Trip", systemImage: "plus.circle.fill")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(red: 1.0, green: 0.42, blue: 0.21))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
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
        AttractionDetailView(
            attraction: AttractionSearchResult(
                id: UUID(),
                name: "Baga Beach",
                address: "Goa, India",
                rating: 4.8,
                latitude: 15.56,
                longitude: 73.75
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
