//
//  HotelCardView.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct HotelCardView: View {

    @Environment(\.modelContext) private var modelContext

    let hotel: HotelSearchResult
    let trip: Trip

    @State private var isAdded = false

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Hotel Info
            HStack(alignment: .top, spacing: 14) {

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(clay)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(hotel.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(ink)
                        .lineLimit(1)

                    Label(hotel.address, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 12))
                        .foregroundStyle(stone)
                        .lineLimit(2)

                    if let rating = hotel.rating {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { i in
                                Image(systemName: i < Int(rating) ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundStyle(
                                        i < Int(rating)
                                        ? clay
                                        : Color.black.opacity(0.15)
                                    )
                            }
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 12))
                                .foregroundStyle(stone)
                        }
                    }
                }

                Spacer()

              
            }

            Divider()
                .overlay(Color.black.opacity(0.06))

            // MARK: - Add Button
            Button {
                addToTrip()
            } label: {
                Label(isAdded ? "Added to Trip" : "Add to Trip", systemImage: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(isAdded ? Color.black.opacity(0.06) : clay)
                    .foregroundStyle(isAdded ? stone : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .disabled(isAdded)
            .padding(.top, 4)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        }
        .animation(.snappy, value: isAdded)
    }

    // MARK: - Add to Trip

    private func addToTrip() {
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
        withAnimation(.snappy) {
            isAdded = true
        }
    }
}

#Preview {
    HotelCardView(
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
    .padding()
    .background(Color(red: 0.97, green: 0.95, blue: 0.92))
    .modelContainer(for: [Trip.self, Hotel.self], inMemory: true)
}
