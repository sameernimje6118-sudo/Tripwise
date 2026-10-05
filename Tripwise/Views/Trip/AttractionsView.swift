//
//  AttractionsView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct AttractionsView: View {

    let trip: Trip

    @Environment(\.modelContext) private var modelContext
    @Query private var attractions: [Attraction]

    var tripAttractions: [Attraction] {
        attractions.filter { $0.tripID == trip.id }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            AppBackground()

            if tripAttractions.isEmpty {
                emptyState
            } else {
                attractionList
            }
        }
        .navigationTitle("Attractions")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar { toolbarItems }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.92, green: 0.98, blue: 0.92))
                    .frame(width: 90, height: 90)

                Image(systemName: "camera.metering.center.weighted")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(red: 0.20, green: 0.70, blue: 0.35))
            }

            VStack(spacing: 6) {
                Text("No Attractions Yet")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Tap + to explore attractions.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            NavigationLink {
                SearchAttractionsView(trip: trip)
            } label: {
                Label("Browse Attractions", systemImage: "plus.circle.fill")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.20, green: 0.70, blue: 0.35))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    // MARK: - Attraction List

    private var attractionList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(tripAttractions) { attraction in
                    attractionCard(attraction)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Attraction Card

    private func attractionCard(_ attraction: Attraction) -> some View {
        HStack(spacing: 14) {

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.92, green: 0.98, blue: 0.92))
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "camera.metering.center.weighted")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(red: 0.20, green: 0.70, blue: 0.35))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(attraction.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Label(attraction.location, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(attraction.rating) ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(
                                i < Int(attraction.rating)
                                ? Color(red: 1.0, green: 0.42, blue: 0.21)
                                : Color.gray.opacity(0.3)
                            )
                    }
                    Text(String(format: "%.1f", attraction.rating))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                withAnimation {
                    modelContext.delete(attraction)
                }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundStyle(.red.opacity(0.7))
                    .padding(8)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            NavigationLink {
                SearchAttractionsView(trip: trip)
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.42, blue: 0.21))
                        .frame(width: 32, height: 32)
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AttractionsView(
            trip: Trip(
                title: "Goa Trip",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
        .modelContainer(for: [Trip.self, Attraction.self], inMemory: true)
    }
}
