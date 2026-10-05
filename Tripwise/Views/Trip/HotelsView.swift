//
//  HotelsView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct HotelsView: View {

    let trip: Trip

    @Environment(\.modelContext) private var modelContext

    @Query private var hotels: [Hotel]

    @State private var showSearchHotels = false

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var tripHotels: [Hotel] {
        hotels.filter { $0.tripID == trip.id }
    }

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            if tripHotels.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tripHotels) { hotel in
                            HotelCard(
                                hotel: hotel,
                                ink: ink,
                                clay: clay,
                                stone: stone,
                                onDelete: { deleteHotel(hotel) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Hotels")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showSearchHotels = true
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
        .navigationDestination(isPresented: $showSearchHotels) {
            SearchHotelsView(trip: trip)
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
                Text("No Hotels")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text("Tap + to add your hotel.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Delete

    private func deleteHotel(_ hotel: Hotel) {
        modelContext.delete(hotel)
        try? modelContext.save()
    }
}

// MARK: - Hotel Card

private struct HotelCard: View {

    let hotel: Hotel
    let ink: Color
    let clay: Color
    let stone: Color
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 64, height: 64)

                Image(systemName: "building.2.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(clay)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(hotel.name)
                    .font(.system(size: 15.5, weight: .bold))
                    .foregroundStyle(ink)
                    .lineLimit(1)

                Label(hotel.location, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)
                    .lineLimit(1)

                HStack(spacing: 10) {
                    Label("\(hotel.rating, specifier: "%.1f")", systemImage: "star.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(clay)

                    Spacer()

                   
                }
                .padding(.top, 2)
            }
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
                Label("Delete Hotel", systemImage: "trash")
            }
        }
        .confirmationDialog(
            "Remove this hotel?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive, action: onDelete)
        } message: {
            Text("This will remove \"\(hotel.name)\" from your trip.")
        }
    }
}

#Preview {
    NavigationStack {
        HotelsView(
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
