//
//  AddTripView.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData
internal import _LocationEssentials

struct AddTripView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var tripName = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var budget = ""
    @State private var isCreating = false
    @State private var errorMessage: String?

    let geocoder = GeocodingService()

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    private var isValid: Bool {
        !tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        startDate <= endDate
    }

    var body: some View {
        NavigationStack {
            ZStack {
                sand.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        previewHero

                        // Trip Details card
                        VStack(alignment: .leading, spacing: 8) {
                            sectionLabel("TRIP DETAILS")

                            VStack(spacing: 0) {
                                CustomField(label: "Trip name", placeholder: "e.g. Summer Europe Trip", text: $tripName, accent: clay)
                                Divider().overlay(Color.black.opacity(0.05)).padding(.leading, 16)
                                CustomField(label: "Destination", placeholder: "e.g. Paris, France", text: $destination, accent: clay)
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            )

                            popularDestinationChips
                        }

                        // Budget card
                        VStack(alignment: .leading, spacing: 8) {
                            sectionLabel("BUDGET")

                            HStack(spacing: 10) {
                                Image(systemName: "indianrupeesign.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(clay)

                                TextField("50000", text: $budget)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 15))
                                    .foregroundStyle(ink)

                                Spacer()

                                if let value = Double(budget), value > 0 {
                                    Text(formattedIndianCurrency(value))
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(stone)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            )

                            budgetQuickChips
                        }

                        // Travel Dates card
                        VStack(alignment: .leading, spacing: 0) {
                            sectionLabel("TRAVEL DATES")

                            VStack(spacing: 0) {
                                CustomDatePicker(
                                    label: "Start date",
                                    iconName: "calendar",
                                    iconBg: clay.opacity(0.12),
                                    iconColor: clay,
                                    tint: clay,
                                    date: $startDate
                                )
                                Divider().overlay(Color.black.opacity(0.05)).padding(.leading, 16)
                                CustomDatePicker(
                                    label: "End date",
                                    iconName: "calendar.badge.clock",
                                    iconBg: clay.opacity(0.12),
                                    iconColor: clay,
                                    tint: clay,
                                    date: $endDate
                                )
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            )

                            if startDate > endDate {
                                Label("End date must be after start date", systemImage: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(clay)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                        }

                        // Hint
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(stone)

                            Text("You can add flights, hotels and activities after creating your trip.")
                                .font(.system(size: 12))
                                .foregroundStyle(stone)
                        }
                        .padding(14)
                        .background(.white.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                        )

                        if let errorMessage {
                            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(clay)
                        }

                        // Create button
                        Button {
                            createTrip()
                        } label: {
                            HStack(spacing: 8) {
                                if isCreating {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "checkmark.circle.badge.airplane")
                                        .font(.system(size: 15, weight: .semibold))
                                }

                                Text(isCreating ? "Creating..." : "Create Trip")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(isValid && !isCreating ? clay : stone.opacity(0.4))
                                    .shadow(color: isValid && !isCreating ? clay.opacity(0.35) : .clear, radius: 14, x: 0, y: 6)
                            )
                        }
                        .disabled(!isValid || isCreating)
                        .animation(.snappy, value: isValid)
                    }
                    .padding(20)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(stone)
                }
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .tracking(1.2)
            .foregroundStyle(stone)
            .padding(.leading, 4)
            .padding(.bottom, 8)
    }

    // MARK: - Preview Hero

    private var nightCount: Int {
        max(Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0, 0)
    }

    private var previewHero: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("PREVIEW")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()

                ZStack {
                    Circle()
                        .fill(.white.opacity(0.18))
                        .frame(width: 34, height: 34)

                    Image(systemName: "airplane.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
            }

            Text(tripName.isEmpty ? "Your Trip Name" : tripName)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)

            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.system(size: 11))
                Text(destination.isEmpty ? "Destination" : destination)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.85))

            HStack(spacing: 10) {
                Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) – \(endDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.7))

                if nightCount > 0 {
                    Text("\(nightCount) NIGHT\(nightCount == 1 ? "" : "S")")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.2)))
                }

                if let budgetValue = Double(budget), budgetValue > 0 {
                    Text(compactBudgetLabel(budgetValue))
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.2)))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [ink, ink.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .animation(.snappy, value: tripName)
        .animation(.snappy, value: destination)
        .animation(.snappy, value: budget)
    }

    // MARK: - Popular Destination Chips

    private let popularDestinations = ["Bali", "Goa", "Paris", "Tokyo", "Dubai", "Manali"]

    private var popularDestinationChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text("Popular:")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)

                ForEach(popularDestinations, id: \.self) { place in
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        withAnimation(.snappy) {
                            destination = place
                        }
                    } label: {
                        Text(place)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(destination == place ? .white : ink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                Capsule().fill(destination == place ? clay : Color.black.opacity(0.04))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 2)
        }
    }

    // MARK: - Budget Quick Chips

    private var budgetSuggestions: [Double] = [20_000, 50_000, 100_000, 200_000]

    private var budgetQuickChips: some View {
        HStack(spacing: 8) {
            ForEach(budgetSuggestions, id: \.self) { amount in
                let isSelected = Double(budget) == amount

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    withAnimation(.snappy) {
                        budget = String(Int(amount))
                    }
                } label: {
                    Text(compactBudgetLabel(amount))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(isSelected ? .white : ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(isSelected ? clay : Color.black.opacity(0.04))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    private func compactBudgetLabel(_ value: Double) -> String {
        if value >= 100_000 {
            return "₹\(Int(value / 100_000))L"
        }
        return "₹\(Int(value / 1_000))k"
    }

    /// Full Indian-style grouping, e.g. 100000 -> "₹1,00,000"
    private func formattedIndianCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return "₹\(number)"
    }

    private func createTrip() {
        guard !tripName.isEmpty, !destination.isEmpty else { return }

        isCreating = true
        errorMessage = nil

        Task {
            do {
                let coordinate = try await geocoder.coordinates(for: destination)

                let newTrip = Trip(
                    title: tripName,
                    destination: destination,
                    startDate: startDate,
                    endDate: endDate,
                    budget: Double(budget) ?? 0,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )

                modelContext.insert(newTrip)
                try? modelContext.save()
                isCreating = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                dismiss()

            } catch {
                isCreating = false
                errorMessage = "Couldn't find that destination. Please check the spelling and try again."
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print("❌ Geocoding Error:", error)
            }
        }
    }
}

// MARK: - Subviews

struct CustomField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var accent: Color = Color(red: 0.80, green: 0.47, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct CustomDatePicker: View {
    let label: String
    let iconName: String
    let iconBg: Color
    let iconColor: Color
    var tint: Color = Color(red: 0.80, green: 0.47, blue: 0.35)
    @Binding var date: Date

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(iconBg)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(iconColor)
                )

            DatePicker(label, selection: $date, displayedComponents: .date)
                .font(.system(size: 14, weight: .medium))
                .tint(tint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    AddTripView()
}
