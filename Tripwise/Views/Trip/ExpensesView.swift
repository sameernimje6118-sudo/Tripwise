//
//  ExpensesView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext

    @Query private var expenses: [Expense]
    var tripExpenses: [Expense] {
        expenses.filter { $0.tripID == trip.id }
    }
    @State private var showAddExpense = false

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    // Extra tones used purely for category color-coding, kept in the same warm family as the app palette.
    private let categoryPalette: [Color] = [
        Color(red: 0.80, green: 0.47, blue: 0.35), // clay
        Color(red: 0.60, green: 0.66, blue: 0.52), // sage
        Color(red: 0.79, green: 0.63, blue: 0.42), // sand-gold
        Color(red: 0.55, green: 0.45, blue: 0.36), // walnut
        Color(red: 0.47, green: 0.55, blue: 0.58)  // slate
    ]

    // MARK: - Computed

    private var totalSpent: Double {
        tripExpenses.reduce(0) { $0 + $1.amount }
    }

    private var remainingBudget: Double {
        max(trip.budget - totalSpent, 0)
    }

    private var budgetProgress: Double {
        guard trip.budget > 0 else { return 0 }
        return min(totalSpent / trip.budget, 1.0)
    }

    private var isOverBudget: Bool {
        totalSpent > trip.budget
    }

    /// Category name -> total amount, sorted highest first.
    private var categoryTotals: [(category: String, amount: Double)] {
        let grouped = Dictionary(grouping: tripExpenses, by: { $0.category })
        return grouped
            .map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }

    private func color(for index: Int) -> Color {
        categoryPalette[index % categoryPalette.count]
    }

    private func percentage(for amount: Double) -> Int {
        guard totalSpent > 0 else { return 0 }
        return Int((amount / totalSpent) * 100)
    }

    var body: some View {

        ZStack {
            sand.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    totalCard

                    if !tripExpenses.isEmpty {
                        budgetProgressCard
                        categoryBreakdownCard
                        expenseList
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Expenses")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddExpense = true
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
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView(trip: trip)
        }
    }

    // MARK: - Total Card

    private var totalCard: some View {
        VStack(spacing: 6) {
            Text("Total Spent")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(stone)

            Text("₹\(totalSpent, specifier: "%.0f")")
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundStyle(ink)

            if trip.budget > 0 {
                Text("of ₹\(trip.budget, specifier: "%.0f") budget")
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundStyle(stone)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        }
    }

    // MARK: - Budget Progress

    private var budgetProgressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Budget used")
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(ink)

                Spacer()

                Text("\(Int(budgetProgress * 100))%")
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundStyle(isOverBudget ? .red : clay)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background((isOverBudget ? Color.red : clay).opacity(0.12))
                    .clipShape(Capsule())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.06))

                    Capsule()
                        .fill(isOverBudget ? Color.red.opacity(0.85) : clay)
                        .frame(width: geo.size.width * budgetProgress)
                }
            }
            .frame(height: 6)

            Text(isOverBudget ? "Over budget" : "₹\(remainingBudget, specifier: "%.0f") left")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(isOverBudget ? .red : clay)
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    // MARK: - Category Breakdown (donut + legend)

    private var categoryBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending by category")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(ink)

            HStack(alignment: .center, spacing: 20) {

                ZStack {
                    donutRing

                    VStack(spacing: 1) {
                        Text("\(tripExpenses.count)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(ink)
                        Text("expenses")
                            .font(.system(size: 9.5, weight: .medium))
                            .foregroundStyle(stone)
                    }
                }
                .frame(width: 92, height: 92)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(categoryTotals.prefix(5).enumerated()), id: \.offset) { index, entry in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(color(for: index))
                                .frame(width: 8, height: 8)

                            Text(entry.category)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(ink)
                                .lineLimit(1)

                            Spacer(minLength: 6)

                            Text("\(percentage(for: entry.amount))%")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(stone)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    /// Precomputed (start, end, color) arcs for the donut, as fractions of the full circle.
    private var donutSegments: [(start: Double, end: Double, color: Color)] {
        let total = max(totalSpent, 1)
        var cumulative: Double = 0
        var segments: [(Double, Double, Color)] = []

        for (index, entry) in categoryTotals.enumerated() {
            let start = cumulative / total
            cumulative += entry.amount
            let end = cumulative / total
            segments.append((start, end, color(for: index)))
        }
        return segments
    }

    private var donutRing: some View {
        ZStack {
            ForEach(Array(donutSegments.enumerated()), id: \.offset) { _, segment in
                Circle()
                    .trim(from: segment.start, to: segment.end)
                    .stroke(segment.color, style: StrokeStyle(lineWidth: 12, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
        }
    }

    // MARK: - Expense List

    private var expenseList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All expenses")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(ink)
                .padding(.horizontal, 2)

            LazyVStack(spacing: 10) {
                ForEach(Array(tripExpenses.enumerated()), id: \.element.id) { index, expense in
                    expenseRow(expense, tint: color(for: categoryIndex(for: expense.category)))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteExpense(expense)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }

    private func categoryIndex(for category: String) -> Int {
        categoryTotals.firstIndex(where: { $0.category == category }) ?? 0
    }

    private func expenseRow(_ expense: Expense, tint: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.12))
                    .frame(width: 42, height: 42)

                Image(systemName: icon(for: expense.category))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(tint)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(expense.title)
                    .font(.system(size: 14.5, weight: .bold))
                    .foregroundStyle(ink)

                Text(expense.category)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundStyle(stone)
            }

            Spacer()

            Text("₹\(expense.amount, specifier: "%.0f")")
                .font(.system(size: 14.5, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    private func icon(for category: String) -> String {
        switch category.lowercased() {
        case "food", "restaurant", "dining": return "fork.knife"
        case "hotel", "stay", "accommodation": return "bed.double.fill"
        case "flight", "transport", "travel": return "airplane"
        case "shopping": return "bag.fill"
        case "activity", "activities": return "figure.hiking"
        default: return "indianrupeesign.circle.fill"
        }
    }

    private func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
        try? modelContext.save()
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(clay.opacity(0.12))
                    .frame(width: 90, height: 90)

                Image(systemName: "indianrupeesign.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(clay)
            }

            VStack(spacing: 6) {
                Text("No Expenses")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text("Tap + to add your first expense.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        ExpensesView(
            trip: Trip(
                title: "Goa Vacation",
                destination: "Goa",
                startDate: Date(),
                endDate: Date(),
                budget: 50000

            )
        )
    }
}
