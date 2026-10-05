//
//  TodayPlanView.swift
//  Tripwise
//
//  Created by sameer nimje on 03/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct TodayPlanView: View {

    let trip: Trip

    @Query private var items: [ItineraryItem]

    var todayItems: [ItineraryItem] {

        let calendar = Calendar.current

        return items
            .filter {

                $0.tripID == trip.id &&
                calendar.isDateInToday($0.date)

            }
            .sorted {

                $0.date < $1.date

            }

    }

    var body: some View {

        ZStack {

            AppBackground()

            if todayItems.isEmpty {

                ContentUnavailableView(
                    "Nothing Planned Today",
                    systemImage: "calendar"
                )

            } else {

                List(todayItems) { item in

                    HStack {

                        Image(systemName:
                                item.isCompleted
                              ? "checkmark.circle.fill"
                              : "circle")
                            .foregroundStyle(
                                item.isCompleted ? .green : .orange
                            )

                        VStack(alignment: .leading) {

                            Text(item.title)
                                .font(.headline)

                            Text(item.date.formatted(
                                date: .omitted,
                                time: .shortened
                            ))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        }

                    }

                }
                .scrollContentBackground(.hidden)

            }

        }
        .navigationTitle("Today's Plan")

    }

}
#Preview {

    NavigationStack {

        TodayPlanView(
            trip: Trip(
                title: "Goa",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000
            )
        )
        .modelContainer(
            for: [
                Trip.self,
                ItineraryItem.self
            ],
            inMemory: true
        )

    }

}
