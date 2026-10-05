//
//  TripSummaryCard.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct TripSummaryCard: View {

    let budget: Double
    let spent: Double

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    private let sage = Color(red: 0.51, green: 0.58, blue: 0.45)

    var remaining: Double {
        max(budget - spent, 0)
    }

    var progress: Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            // Header
            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Trip Overview")
                        .font(.system(size: 17, weight: .semibold, design: .serif))
                        .foregroundStyle(ink)

                    Text("Track your travel budget")
                        .font(.system(size: 12))
                        .foregroundStyle(stone)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 38, height: 38)

                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(clay)
                }
            }

            // Summary
            HStack {

                SummaryItem(title: "Budget", value: budget, color: stone)

                Spacer()

                SummaryItem(title: "Spent", value: spent, color: clay)

                Spacer()

                SummaryItem(title: "Left", value: remaining, color: sage)
            }

            VStack(alignment: .leading, spacing: 10) {

                HStack {

                    Text("Budget Usage")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(ink)

                    Spacer()

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(clay)
                }

                ProgressView(value: progress)
                    .tint(clay)
                    .scaleEffect(y: 2)

                Text("₹\(spent, specifier: "%.0f") spent of ₹\(budget, specifier: "%.0f")")
                    .font(.system(size: 12))
                    .foregroundStyle(stone)
            }

        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        TripSummaryCard(
            budget: 50000,
            spent: 18500
        )
        .padding()
    }
}
