//
//  AddItineraryItemView.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct AddItineraryItemView: View {

    let trip: Trip

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTitleFocused: Bool

    @State private var title = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var selectedType = "✈️ Flight"

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    // Same tone family as ItineraryRow/ExpensesView, so a type looks identical everywhere.
    private let slateBlue = Color(red: 0.42, green: 0.51, blue: 0.62)
    private let plum = Color(red: 0.60, green: 0.48, blue: 0.55)
    private let sage = Color(red: 0.51, green: 0.58, blue: 0.45)
    private let gold = Color(red: 0.72, green: 0.55, blue: 0.30)
    private let walnut = Color(red: 0.55, green: 0.45, blue: 0.36)

    private let eventTypes = [
        "✈️ Flight",
        "🏨 Hotel",
        "📸 Attraction",
        "🍽 Restaurant",
        "🚖 Transport",
        "🛍 Shopping",
        "☕ Coffee",
        "🎉 Activity"
    ]

    private func icon(for type: String) -> String {
        switch type {
        case "✈️ Flight": return "airplane"
        case "🏨 Hotel": return "bed.double.fill"
        case "📸 Attraction": return "camera.fill"
        case "🍽 Restaurant": return "fork.knife"
        case "🚖 Transport": return "car.fill"
        case "🛍 Shopping": return "bag.fill"
        case "☕ Coffee": return "cup.and.saucer.fill"
        default: return "star.fill"
        }
    }

    private func color(for type: String) -> Color {
        switch type {
        case "✈️ Flight": return clay
        case "🏨 Hotel": return slateBlue
        case "🍽 Restaurant": return sage
        case "📸 Attraction": return plum
        case "🚖 Transport": return walnut
        case "🛍 Shopping": return gold
        case "☕ Coffee": return walnut
        default: return stone
        }
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {

        ZStack {
            sand.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {

                    previewCard
                    nameField
                    typeGrid
                    locationField
                    dateField
                    saveButton
                }
                .padding(20)
            }
        }
        .navigationTitle("Add Event")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(stone)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isTitleFocused = false }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTitleFocused = true
            }
        }
    }

    // MARK: - Live Preview Card

    private var previewCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(color(for: selectedType).opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: icon(for: selectedType))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(color(for: selectedType))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title.isEmpty ? "Event title" : title)
                    .font(.system(size: 15.5, weight: .bold))
                    .foregroundStyle(ink)
                    .lineLimit(1)

                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)

                if !location.isEmpty {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(stone)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .animation(.snappy, value: title)
        .animation(.snappy, value: location)
        .animation(.snappy, value: selectedType)
        .animation(.snappy, value: date)
    }

    // MARK: - Name Field

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("EVENT")

            TextField("e.g. Flight to Goa", text: $title)
                .focused($isTitleFocused)
                .font(.system(size: 15))
                .foregroundStyle(ink)
                .padding(15)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                }
        }
    }

    // MARK: - Type Grid

    private var typeGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("TYPE")

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                ForEach(eventTypes, id: \.self) { type in
                    typeTile(for: type)
                }
            }
        }
    }

    private func typeTile(for type: String) -> some View {
        let tint = color(for: type)
        let selected = type == selectedType
        // Strip the emoji prefix for a cleaner label under the icon.
        let label = type.split(separator: " ").dropFirst().joined(separator: " ")

        return Button {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.spring(duration: 0.3)) {
                selectedType = type
            }
        } label: {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(selected ? tint.opacity(0.15) : tint.opacity(0.1))
                    .frame(width: 46, height: 46)
                    .overlay {
                        Image(systemName: icon(for: type))
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(tint)
                    }

                Text(label)
                    .font(.system(size: 11.5, weight: selected ? .semibold : .regular))
                    .foregroundStyle(selected ? tint : stone)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(selected ? tint.opacity(0.06) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        selected ? tint.opacity(0.35) : Color.black.opacity(0.06),
                        lineWidth: selected ? 1.2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Location Field

    private var locationField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("LOCATION")

            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(stone)
                TextField("Optional, e.g. Mumbai → Goa", text: $location)
                    .font(.system(size: 15))
                    .foregroundStyle(ink)
            }
            .padding(15)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            }
        }
    }

    // MARK: - Date Field

    private var dateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("DATE & TIME")

            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .tint(clay)
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                }

            quickTimeChips
        }
    }

    private var quickTimeChips: some View {
        HStack(spacing: 8) {
            ForEach([("Morning", 9), ("Afternoon", 14), ("Evening", 19)], id: \.0) { label, hour in
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    if let newDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                        withAnimation(.snappy) {
                            date = newDate
                        }
                    }
                } label: {
                    Text(label)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.04))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button {
            saveItem()
        } label: {
            Label("Save Event", systemImage: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? clay : stone.opacity(0.35))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: isFormValid ? clay.opacity(0.35) : .clear, radius: 14, x: 0, y: 6)
        }
        .disabled(!isFormValid)
        .animation(.snappy, value: isFormValid)
    }

    private func saveItem() {
        let item = ItineraryItem(
            tripID: trip.id,
            title: title,
            date: date,
            type: selectedType,
            location: location
        )

        modelContext.insert(item)
        try? modelContext.save()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismiss()
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .tracking(1.0)
            .foregroundStyle(stone)
            .padding(.leading, 4)
    }
}

#Preview {

    NavigationStack {

        AddItineraryItemView(
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
