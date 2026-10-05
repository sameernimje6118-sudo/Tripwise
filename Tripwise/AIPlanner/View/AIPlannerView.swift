//
//  AIPlannerView.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIPlannerView: View {

    @State private var destination = ""
    @State private var departureCity = ""
    @State private var departureDate = Date()

    @State private var days = 5
    @State private var travellers = 2

    @State private var budget = ""
    @State private var selectedInterests: Set<String> = []
    @State private var extraInterests = ""

    @State private var isLoading = false
    @State private var errorMessage = ""

    @State private var generatedTrip: AITrip?
    @FocusState private var isDestinationFocused: Bool

    private let service = GeminiService()

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    private let interestOptions = [
        "Beaches", "Adventure", "Food", "Culture",
        "Nightlife", "Shopping", "Nature", "Relaxation"
    ]

    private let budgetSuggestions: [Double] = [20_000, 50_000, 100_000, 200_000]

    private var combinedInterests: String {
        let tags = selectedInterests.joined(separator: ", ")
        let extra = extraInterests.trimmingCharacters(in: .whitespacesAndNewlines)
        if tags.isEmpty { return extra }
        if extra.isEmpty { return tags }
        return "\(tags), \(extra)"
    }

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    header

                    tripBasicsCard

                    counterCard

                    budgetCard

                    interestsCard

                    if !errorMessage.isEmpty {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.red.opacity(0.85))
                    }

                    generateButton
                }
                .padding(20)
            }

            if isLoading {
                LoadingView()
            }
        }
        .navigationDestination(item: $generatedTrip) { trip in
            AIResultView(trip: trip)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(clay.opacity(0.12))
                    .frame(width: 60, height: 60)

                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(clay)
            }
            .padding(.bottom, 6)

            Text("AI Travel Planner")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(ink)

            Text("Create your perfect itinerary with AI")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(stone)
        }
    }

    // MARK: - Trip Basics Card

    private var tripBasicsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionLabel("TRIP BASICS")

            VStack(spacing: 0) {
                labeledField(label: "Destination", placeholder: "e.g. Bali, Indonesia", text: $destination, focus: $isDestinationFocused)
                Divider().overlay(Color.black.opacity(0.05)).padding(.leading, 16)
                labeledField(label: "Departure City", placeholder: "e.g. Mumbai", text: $departureCity)
                Divider().overlay(Color.black.opacity(0.05)).padding(.leading, 16)

                HStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(clay.opacity(0.12))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "calendar")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(clay)
                        )

                    DatePicker("Departure date", selection: $departureDate, displayedComponents: .date)
                        .font(.system(size: 14, weight: .medium))
                        .tint(clay)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
    }

    private func labeledField(label: String, placeholder: String, text: Binding<String>, focus: FocusState<Bool>.Binding? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(stone)

            Group {
                if let focus {
                    TextField(placeholder, text: text)
                        .focused(focus)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .font(.system(size: 15))
            .foregroundStyle(ink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Counter Card (Days / Travellers)

    private var counterCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("TRIP LENGTH")

            HStack(spacing: 10) {
                counter(label: "Days", value: $days, range: 1...30)
                counter(label: "Travellers", value: $travellers, range: 1...20)
            }
        }
    }

    private func counter(label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(spacing: 10) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(stone)

            Text("\(value.wrappedValue)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(ink)

            HStack(spacing: 16) {
                stepButton(systemImage: "minus") {
                    if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 }
                }
                stepButton(systemImage: "plus") {
                    if value.wrappedValue < range.upperBound { value.wrappedValue += 1 }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }

    private func stepButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(clay)
                .frame(width: 30, height: 30)
                .background(clay.opacity(0.12))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Budget Card

    private var budgetCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("BUDGET")

            HStack(spacing: 10) {
                Image(systemName: "indianrupeesign.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(clay)

                TextField("50000", text: $budget)
                    .keyboardType(.numberPad)
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
        }
    }

    private func compactBudgetLabel(_ value: Double) -> String {
        if value >= 100_000 {
            return "₹\(Int(value / 100_000))L"
        }
        return "₹\(Int(value / 1_000))k"
    }

    private func formattedIndianCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return "₹\(number)"
    }

    // MARK: - Interests Card

    private var interestsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("INTERESTS")

            FlowChips(
                options: interestOptions,
                selected: $selectedInterests,
                ink: ink,
                clay: clay,
                stone: stone
            )

            TextField("Anything else? e.g. scuba diving, local markets", text: $extraInterests)
                .font(.system(size: 14))
                .foregroundStyle(ink)
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )
                .padding(.top, 4)
        }
    }

    // MARK: - Generate Button

    private var generateButton: some View {
        Button {
            Task { await createTrip() }
        } label: {
            Label("Generate Trip", systemImage: "sparkles")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(clay)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: clay.opacity(0.35), radius: 14, x: 0, y: 6)
        }
        .disabled(isLoading)
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .tracking(1.2)
            .foregroundStyle(stone)
            .padding(.leading, 4)
            .padding(.bottom, 8)
    }

    // MARK: - Create Trip

    @MainActor
    private func createTrip() async {

        guard !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a destination."
            return
        }
        guard !departureCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter your departure city."
            return
        }
        guard let amount = Double(budget), amount > 0 else {
            errorMessage = "Please enter a valid budget."
            return
        }

        errorMessage = ""
        isLoading = true

        do {
            let result = try await service.generateTrip(
                destination: destination,
                departureCity: departureCity,
                departureDate: departureDate,
                days: days,
                travellers: travellers,
                budget: amount,
                interests: combinedInterests
            )

            generatedTrip = result

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// MARK: - Flow Chips (interest tags)

private struct FlowChips: View {
    let options: [String]
    @Binding var selected: Set<String>
    let ink: Color
    let clay: Color
    let stone: Color

    private let columns = [
        GridItem(.adaptive(minimum: 90), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(options, id: \.self) { option in
                let isSelected = selected.contains(option)

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    withAnimation(.snappy) {
                        if isSelected {
                            selected.remove(option)
                        } else {
                            selected.insert(option)
                        }
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundStyle(isSelected ? .white : ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(isSelected ? clay : Color.black.opacity(0.04)))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AIPlannerView()
    }
}
