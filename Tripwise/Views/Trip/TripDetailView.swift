//
//  TripDetailView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//
import SwiftUI
import SwiftData

struct TripDetailView: View {

    let trip: Trip
    @Query private var expenses: [Expense]

    @Environment(\.modelContext) private var modelContext
    @State private var showEditBudgetSheet = false
    @State private var editedBudgetText: String = ""

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var tripExpenses: [Expense] {
        expenses.filter { $0.tripID == trip.id }
    }

    var totalSpent: Double {
        tripExpenses.reduce(0) { $0 + $1.amount }
    }

    /// Budget not yet spent, floored at 0 so overspending doesn't show a negative "left" amount.
    var remainingBudget: Double {
        max(trip.budget - totalSpent, 0)
    }

    private var budgetProgress: Double {
        guard trip.budget > 0 else { return 0 }
        return min(totalSpent / trip.budget, 1.0)
    }

    private var isOverBudget: Bool {
        totalSpent > trip.budget
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }

    /// Whole-trip length as "X Days • Y Nights", the way the reference layout shows it.
    private var tripDuration: (days: Int, nights: Int) {
        let dayCount = Calendar.current.dateComponents(
            [.day], from: trip.startDate, to: trip.endDate
        ).day ?? 0
        return (max(dayCount + 1, 1), max(dayCount, 0))
    }

    private let gridColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            sand.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    heroSection

                    budgetProgressCard

                    statsBar

                    atAGlanceGrid

                    aiPlannerCard

                    NavigationLink {
                        SavedAIPlansView()
                    } label: {
                        FeatureRow(title: "Saved AI Plans", icon: "bookmark.fill", color: clay)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }

            if showEditBudgetSheet {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showEditBudgetSheet = false
                        }
                    }
                    .transition(.opacity)

                EditBudgetPopup(
                    currentBudget: trip.budget,
                    ink: ink,
                    clay: clay,
                    stone: stone,
                    onCancel: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showEditBudgetSheet = false
                        }
                    },
                    onSave: { newBudget in
                        trip.budget = newBudget
                        try? modelContext.save()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            showEditBudgetSheet = false
                        }
                    }
                )
                .padding(.horizontal, 32)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showEditBudgetSheet)
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 8) {

            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 84, height: 84)
                    .overlay(
                        Circle().strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                    )

                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 34, weight: .light))
                    .foregroundStyle(clay)
            }
            .padding(.bottom, 4)

            Text(trip.destination.uppercased())
                .font(.system(size: 12, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(clay)

            Text(trip.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(ink)
                .multilineTextAlignment(.center)

            Text("\(tripDuration.days) Days • \(tripDuration.nights) Nights")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(stone)

            Text("\(dateFormatter.string(from: trip.startDate)) – \(dateFormatter.string(from: trip.endDate))")
                .font(.system(size: 12.5))
                .foregroundStyle(stone.opacity(0.85))
        }
        .padding(.top, 20)
    }

    // MARK: - Budget Progress

    private var budgetProgressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Budget")
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

                Text("\(compactCurrency(totalSpent)) / \(compactCurrency(trip.budget))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(stone)
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

            HStack {
                Text(isOverBudget ? "Over budget" : "\(compactCurrency(remainingBudget)) left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isOverBudget ? .red : clay)

                Spacer()

                Text("Tap to edit")
                    .font(.system(size: 10.5, weight: .medium))
                    .foregroundStyle(stone.opacity(0.7))
            }
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            editedBudgetText = String(Int(trip.budget))
            showEditBudgetSheet = true
        }
    }

    // MARK: - Stats Bar

    private var statsBar: some View {
        HStack(spacing: 0) {

            statItem(label: "Start", value: dateFormatter.string(from: trip.startDate))

            divider

            statItem(label: "End", value: dateFormatter.string(from: trip.endDate))

            divider

            statItem(label: "Budget", value: compactCurrency(trip.budget))

            divider

            statItem(label: "Left", value: compactCurrency(remainingBudget))
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
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(stone)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.06))
            .frame(width: 1, height: 30)
    }

    private func compactCurrency(_ value: Double) -> String {
        if value >= 100_000 {
            return "₹\(String(format: "%.1f", value / 100_000))L"
        } else if value >= 1_000 {
            return "₹\(String(format: "%.1f", value / 1_000))k"
        }
        return "₹\(Int(value))"
    }

    // MARK: - At a Glance Grid

    private var atAGlanceGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("At a glance")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(ink)
                .padding(.horizontal, 2)

            LazyVGrid(columns: gridColumns, spacing: 10) {
                NavigationLink {
                    ExpensesView(trip: trip)
                } label: {
                    GlanceTile(title: "Expenses", subtitle: "\(tripExpenses.count) logged", icon: "indianrupeesign.circle.fill", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    NotesView(trip: trip)
                } label: {
                    GlanceTile(title: "Notes", subtitle: "\(trip.notes.count) saved", icon: "note.text", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    HotelsView(trip: trip)
                } label: {
                    GlanceTile(title: "Hotels", subtitle: "View stays", icon: "bed.double.fill", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
                
               

                NavigationLink {
                    AttractionsView(trip: trip)
                } label: {
                    GlanceTile(title: "Attractions", subtitle: "Places to see", icon: "camera.metering.center.weighted", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    RestaurantsView(trip: trip)
                } label: {
                    GlanceTile(title: "Restaurants", subtitle: "Where to eat", icon: "fork.knife", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    ItineraryView(trip: trip)
                } label: {
                    GlanceTile(title: "Itinerary", subtitle: "\(tripDuration.days) day plan", icon: "map.fill", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)

                
                NavigationLink {
                    WeatherView(
                        latitude: trip.latitude,
                        longitude: trip.longitude,
                        city: trip.destination
                    )
                } label: {
                    GlanceTile(title: "Weather", subtitle: "Forecast", icon: "cloud.sun.fill", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    TripMapView(trip: trip)
                } label: {
                    GlanceTile(title: "Trip Map", subtitle: "See on map", icon: "map.fill", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)

                
                NavigationLink {
                    FlightsView(trip: trip)
                } label: {
                    GlanceTile(title: "Flights", subtitle: "View bookings", icon: "airplane", ink: ink, clay: clay, stone: stone)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - AI Planner Highlight Card

    private var aiPlannerCard: some View {
        NavigationLink {
            AIPlannerView()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 42, height: 42)

                    Image(systemName: "sparkles")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(clay)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Trip Planner")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(ink)

                    Text("Generate your perfect travel plan")
                        .font(.system(size: 12))
                        .foregroundStyle(stone)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(stone)
            }
            .padding(14)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Glance Tile

private struct GlanceTile: View {

    let title: String
    let subtitle: String
    let icon: String
    let ink: Color
    let clay: Color
    let stone: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(clay.opacity(0.12))
                    .frame(width: 34, height: 34)

                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(clay)
            }

            Text(title)
                .font(.system(size: 13.5, weight: .bold))
                .foregroundStyle(ink)

            Text(subtitle)
                .font(.system(size: 10.5, weight: .medium))
                .foregroundStyle(stone)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Edit Budget Popup (centered modal, not a bottom sheet)

private struct EditBudgetPopup: View {

    let currentBudget: Double
    let ink: Color
    let clay: Color
    let stone: Color
    let onCancel: () -> Void
    let onSave: (Double) -> Void

    @State private var budgetText: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 18) {
            Text("Edit Budget")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(ink)

            HStack {
                Text("₹")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(clay)

                TextField("0", text: $budgetText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(ink)
                    .focused($isFocused)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            HStack(spacing: 8) {
                ForEach([5000, 10000, 25000], id: \.self) { amount in
                    Button {
                        let current = Double(budgetText) ?? currentBudget
                        budgetText = String(Int(current) + amount)
                    } label: {
                        Text("+₹\(amount / 1000)k")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(clay)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 7)
                            .background(clay.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }

            HStack(spacing: 10) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.05))
                        .foregroundStyle(stone)
                        .clipShape(Capsule())
                }

                Button {
                    if let value = Double(budgetText), value > 0 {
                        onSave(value)
                    }
                } label: {
                    Text("Save")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(clay)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 10)
        .onAppear {
            budgetText = String(Int(currentBudget))
            isFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        TripDetailView(
            trip: Trip(
                title: "Goa Vacation",
                destination: "Goa",
                startDate: .now,
                endDate: .now
            )
        )
    }
}
