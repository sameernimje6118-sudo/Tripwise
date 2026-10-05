//
//  AIBudgetCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIBudgetCard: View {

    let budget: AIBudget

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    private let moss = Color(red: 0.42, green: 0.56, blue: 0.38)

    // Same tone family as ExpensesView/ItineraryRow, so a category reads
    // identically everywhere in the app.
    private let slateBlue = Color(red: 0.42, green: 0.51, blue: 0.62)
    private let sage = Color(red: 0.51, green: 0.58, blue: 0.45)
    private let plum = Color(red: 0.60, green: 0.48, blue: 0.55)
    private let gold = Color(red: 0.72, green: 0.55, blue: 0.30)
    private let walnut = Color(red: 0.55, green: 0.45, blue: 0.36)

    private var totalValue: Double {
        amount(from: budget.total)
    }

    private var remainingValue: Double {
        amount(from: budget.remaining)
    }

    private var spentValue: Double {
        max(totalValue - remainingValue, 0)
    }

    private var progress: Double {
        guard totalValue > 0 else { return 0 }
        return min(spentValue / totalValue, 1)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Budget")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text(budget.total)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(ink)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "indianrupeesign.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Budget Usage")
                        .font(.system(size: 13.5, weight: .bold))
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
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 12) {
                budgetRow(icon: "airplane", title: "Flights", value: budget.flights, tint: clay)
                budgetRow(icon: "bed.double.fill", title: "Hotel", value: budget.hotel, tint: slateBlue)
                budgetRow(icon: "fork.knife", title: "Food", value: budget.food, tint: sage)
                budgetRow(icon: "car.fill", title: "Transport", value: budget.transport, tint: walnut)
                budgetRow(icon: "camera.fill", title: "Activities", value: budget.activities, tint: plum)
                budgetRow(icon: "bag.fill", title: "Shopping", value: budget.shopping, tint: gold)
                budgetRow(icon: "shippingbox.fill", title: "Miscellaneous", value: budget.miscellaneous, tint: stone)
            }

            Divider().overlay(Color.black.opacity(0.06))

            HStack {
                Text("Remaining")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ink)

                Spacer()

                Text(budget.remaining)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(moss)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func budgetRow(icon: String, title: String, value: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(tint.opacity(0.12))
                    .frame(width: 30, height: 30)

                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(tint)
            }

            Text(title)
                .font(.system(size: 13.5, weight: .medium))
                .foregroundStyle(ink)

            Spacer()

            Text(value)
                .font(.system(size: 13.5, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
        }
    }

    private func amount(from text: String) -> Double {
        let filtered = text.filter { "0123456789.".contains($0) }
        return Double(filtered) ?? 0
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AIBudgetCard(
            budget: AIBudget(
                flights: "₹5,500",
                hotel: "₹18,000",
                food: "₹6,000",
                transport: "₹3,000",
                activities: "₹4,000",
                shopping: "₹2,000",
                miscellaneous: "₹1,500",
                remaining: "₹10,000",
                total: "₹50,000"
            )
        )
        .padding()

    }

}
