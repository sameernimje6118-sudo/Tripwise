//
//  TripCardView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct TripCardView: View {

    let trip: Trip

    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation = false

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    // Rotates through a few warm tile colors so a list of cards doesn't look flat.
    // Swap these for real trip photos when you have image data on Trip.
    private let tileColors: [Color] = [
        Color(red: 0.80, green: 0.47, blue: 0.35), // clay
        Color(red: 0.72, green: 0.77, blue: 0.65), // sage
        Color(red: 0.85, green: 0.73, blue: 0.55), // sand-gold
        Color(red: 0.66, green: 0.54, blue: 0.41)  // walnut
    ]

    private var tileColor: Color {
        tileColors[abs(trip.title.hashValue) % tileColors.count]
    }

    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return "\(formatter.string(from: trip.startDate)) – \(formatter.string(from: trip.endDate))"
    }

    var body: some View {
        NavigationLink {
            TripDetailView(trip: trip)
        } label: {
            HStack(spacing: 14) {

                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(tileColor)

                    Image(systemName: "airplane")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(45))
                }
                .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.title)
                        .font(.system(size: 15.5, weight: .bold))
                        .foregroundStyle(ink)
                        .lineLimit(1)

                    Label(trip.destination, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(stone)
                        .lineLimit(1)

                    Text(dateRangeText)
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundStyle(stone.opacity(0.85))
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(stone.opacity(0.5))
            }
            .padding(12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete Trip", systemImage: "trash")
            }
        }
        .confirmationDialog(
            "Delete this trip?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                modelContext.delete(trip)
                try? modelContext.save()
            }
        } message: {
            Text("This will permanently delete \"\(trip.title)\" and cannot be undone.")
        }
    }
}

#Preview {
    TripCardView(
        trip: Trip(
            title: "Goa Vacation",
            destination: "Goa",
            startDate: .now,
            endDate: .now
        )
    )
    .padding()
    .background(Color(red: 0.97, green: 0.95, blue: 0.92))
    .modelContainer(for: Trip.self, inMemory: true)
}
