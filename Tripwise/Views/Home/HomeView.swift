//
//  HomeView.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Trip.startDate)
    private var trips: [Trip]

    @Query
    private var expenses: [Expense]

    @State private var searchText: String = ""

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    // MARK: - Computed Properties

    private var totalBudget: Double {
        trips.reduce(0) { $0 + $1.budget }
    }

    private var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    /// Trips that haven't started yet, soonest first.
    private var upcomingTrips: [Trip] {
        trips.filter { $0.startDate > Date() }
    }

    /// Trips that have already started/finished, most recent first.
    /// Capped to 4 here; full list lives in AllTripsView.
    private var recentTrips: [Trip] {
        trips
            .filter { $0.startDate <= Date() }
            .sorted { $0.startDate > $1.startDate }
    }

    /// Live search across every trip, not just the visible sections.
    /// NOTE: adjust `trip.destination` below if your Trip model uses a
    /// different property name (e.g. `trip.name`).
    private var searchResults: [Trip] {
        guard !searchText.isEmpty else { return [] }
        return trips.filter {
            $0.destination.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var isSearching: Bool {
        !searchText.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                sand.ignoresSafeArea()

                VStack(spacing: 20) {
                    statsBar

                    searchBar

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if isSearching {
                                searchResultsList
                            } else if trips.isEmpty {
                                emptyState
                            } else {
                                if !upcomingTrips.isEmpty {
                                    upcomingSection
                                }
                                if !recentTrips.isEmpty {
                                    recentSection
                                }
                            }
                        }
                        .padding(.top, 8)
                    }

                    if !isSearching {
                        newTripButton
                    }
                }
                .padding()
            }
            .navigationTitle("My Trips")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(stone)

            TextField("Search your trips...", text: $searchText)
                .font(.system(size: 14))
                .foregroundStyle(ink)

            if isSearching {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(stone)
                }
            }
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Search Results

    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 14) {
            if searchResults.isEmpty {
                VStack(spacing: 6) {
                    Text("No trips found")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(ink)
                    Text("Try a different destination or trip name.")
                        .font(.system(size: 13))
                        .foregroundStyle(stone)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else {
                Text("\(searchResults.count) result\(searchResults.count == 1 ? "" : "s")")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)

                LazyVStack(spacing: 14) {
                    ForEach(searchResults) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            TripCardView(trip: trip)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Stats Bar

    private var statsBar: some View {
        HStack(spacing: 0) {

            statItem(label: "Trips", value: "\(trips.count)")

            divider

            statItem(label: "Upcoming", value: "\(upcomingTrips.count)")

            divider

            statItem(label: "Budget", value: "₹\(compactNumber(totalBudget))")

            divider

            statItem(label: "Spent", value: "₹\(compactNumber(totalSpent))")
        }
        .padding(.vertical, 18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .tracking(0.4)
                .foregroundStyle(stone)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.06))
            .frame(width: 1, height: 34)
    }

    private func compactNumber(_ value: Double) -> String {
        if value >= 100_000 {
            return String(format: "%.1fL", value / 100_000)
        } else if value >= 1_000 {
            return String(format: "%.1fk", value / 1_000)
        }
        return "\(Int(value))"
    }

    // MARK: - Upcoming Section (horizontal scroll)

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming trips")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(ink)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(upcomingTrips) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            UpcomingTripCard(trip: trip, ink: ink, clay: clay)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
    }

    // MARK: - Recent Section (with See all)

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent trips")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Spacer()

                NavigationLink {
                    AllTripsView(trips: recentTrips)
                } label: {
                    Text("See all")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(clay)
                }
            }
            .padding(.horizontal, 4)

            LazyVStack(spacing: 14) {
                ForEach(recentTrips.prefix(4)) { trip in
                    NavigationLink {
                        TripDetailView(trip: trip)
                    } label: {
                        TripCardView(trip: trip)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 24)

            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                    )

                Image(systemName: "airplane")
                    .font(.system(size: 34, weight: .light))
                    .foregroundStyle(clay)
                    .rotationEffect(.degrees(45))
            }
            .padding(.top, 8)

            VStack(spacing: 6) {
                Text("No trips yet")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(ink)

                Text("Start by creating your first journey.")
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(stone)
            }

            Spacer(minLength: 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    // MARK: - New Trip Button

    private var newTripButton: some View {
        NavigationLink {
            AddTripView()
        } label: {
            Label("New Trip", systemImage: "plus")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(clay)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: clay.opacity(0.35), radius: 14, x: 0, y: 6)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

// MARK: - Upcoming Trip Card (horizontal)

private struct UpcomingTripCard: View {

    let trip: Trip
    let ink: Color
    let clay: Color

    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: trip.startDate).day ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(trip.destination)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(trip.startDate, format: .dateTime.day().month(.abbreviated))
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.8))

            Spacer(minLength: 8)

            Text("\(daysLeft) days left")
                .font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.18))
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(16)
        .frame(width: 170, height: 130, alignment: .topLeading)
        .background(clay)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    HomeView()
}
