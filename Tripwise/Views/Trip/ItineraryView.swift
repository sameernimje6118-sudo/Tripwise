//
//  ItineraryView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct ItineraryView: View {

    let trip: Trip

    @Query private var items: [ItineraryItem]
    @Query private var flights: [Flight]
    @Query private var hotels: [Hotel]
    @Query private var attractions: [Attraction]
    @Query private var restaurants: [Restaurant]

    @Environment(\.modelContext) private var modelContext

    @State private var showRegenerateConfirmation = false
    @State private var editMode: EditMode = .inactive

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var tripItems: [ItineraryItem] {
        items
            .filter { $0.tripID == trip.id }
            .sorted { $0.date < $1.date }
    }

    var completedCount: Int {
        tripItems.filter { $0.isCompleted }.count
    }

    var progress: Double {
        guard !tripItems.isEmpty else { return 0 }
        return Double(completedCount) / Double(tripItems.count)
    }

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            if tripItems.isEmpty {
                emptyState
            } else {
                List {
                    Section {
                        progressCard
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }

                    ForEach(groupedItems, id: \.0) { day, events in
                        Section {
                            ForEach(events) { item in
                                ItineraryRow(item: item)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                            }
                            .onMove { indices, newOffset in
                                reorder(day: day, events: events, from: indices, to: newOffset)
                            }
                        } header: {
                            Text(day.formatted(date: .complete, time: .omitted).uppercased())
                                .font(.system(size: 12, weight: .bold))
                                .tracking(0.8)
                                .foregroundStyle(stone)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .environment(\.editMode, $editMode)
            }
        }
        .navigationTitle("Itinerary")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {

            

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        editMode = editMode == .active ? .inactive : .active
                    }
                } label: {
                    Text(editMode == .active ? "Done" : "Reorder")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(clay)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddItineraryItemView(trip: trip)
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
                    Image(systemName: "calendar")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(clay)
                }

            VStack(spacing: 6) {
                Text("No Itinerary Yet")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text("Start building your trip timeline.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 10) {
                NavigationLink {
                    AddItineraryItemView(trip: trip)
                } label: {
                    Label("Add Event", systemImage: "plus.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(clay)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .shadow(color: clay.opacity(0.35), radius: 14, x: 0, y: 6)
                }

         
            }
            .padding(.horizontal, 32)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Progress Card

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Trip Progress")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(ink)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(clay)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(clay.opacity(0.12))
                    .clipShape(Capsule())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.06))

                    Capsule()
                        .fill(clay)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 6)

            Text("\(completedCount) of \(tripItems.count) activities completed")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(stone)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Reorder (persists order by spacing out each item's time within the day)

    private func reorder(day: Date, events: [ItineraryItem], from indices: IndexSet, to newOffset: Int) {
        var reordered = events
        reordered.move(fromOffsets: indices, toOffset: newOffset)

        // Spread items 45 minutes apart starting from the day's original earliest time,
        // so the stored `date` (which drives both sorting and the row's time badge)
        // reflects the new manual order instead of jumbling on next fetch.
        let dayStart = Calendar.current.startOfDay(for: day)
        let baseHour = Calendar.current.dateComponents([.hour, .minute], from: events.first?.date ?? dayStart)

        var runningTime = Calendar.current.date(
            bySettingHour: baseHour.hour ?? 9,
            minute: baseHour.minute ?? 0,
            second: 0,
            of: dayStart
        ) ?? dayStart

        for item in reordered {
            item.date = runningTime
            runningTime = runningTime.addingTimeInterval(45 * 60)
        }

        try? modelContext.save()
    }

    // MARK: - Generate Itinerary
    private func icon(for type: String) -> String {
        switch type {
        case "✈️ Flight":
            return "airplane"
        case "🏨 Hotel":
            return "bed.double.fill"
        case "📸 Attraction":
            return "camera.fill"
        case "🍽 Restaurant":
            return "fork.knife"
        case "🚖 Transport":
            return "car.fill"
        case "🛍 Shopping":
            return "bag.fill"
        case "☕ Coffee":
            return "cup.and.saucer.fill"
        default:
            return "star.fill"
        }
    }

    private var groupedItems: [(Date, [ItineraryItem])] {
        let grouped = Dictionary(
            grouping: tripItems.sorted { $0.date < $1.date }
        ) {
            Calendar.current.startOfDay(for: $0.date)
        }

        return grouped
            .sorted { $0.key < $1.key }
    }
}

#Preview {

    let container = try! ModelContainer(
        for: Trip.self, ItineraryItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = container.mainContext

    let trip = Trip(
        title: "Goa Trip",
        destination: "Goa",
        startDate: .now,
        endDate: .now.addingTimeInterval(60 * 60 * 24 * 5),
        budget: 50000
    )

    context.insert(trip)

    context.insert(
        ItineraryItem(
            tripID: trip.id,
            title: "Flight to Goa",
            date: .now,
            type: "✈️ Flight",
            location: "Mumbai → Goa",
            isGenerated: true
        )
    )

    return NavigationStack {
        ItineraryView(trip: trip)
    }
    .modelContainer(container)
}
