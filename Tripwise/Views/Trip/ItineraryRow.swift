//
//  ItineraryRow.swift
//  Tripwise
//
//  Created by sameer nimje on 05/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData

struct ItineraryRow: View {

    @Bindable var item: ItineraryItem

    @Environment(\.modelContext) private var modelContext
    @State private var showEditSheet = false

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    private let moss = Color(red: 0.42, green: 0.56, blue: 0.38)

    // Extra tones for type color-coding, kept in the same warm family as the app palette
    // (same family used for expense categories, so the whole app reads as one system).
    private let slateBlue = Color(red: 0.42, green: 0.51, blue: 0.62)
    private let plum = Color(red: 0.60, green: 0.48, blue: 0.55)
    private let sage = Color(red: 0.51, green: 0.58, blue: 0.45)
    private let gold = Color(red: 0.72, green: 0.55, blue: 0.30)
    private let walnut = Color(red: 0.55, green: 0.45, blue: 0.36)

    var body: some View {

        Button {
            withAnimation(.spring()) {
                item.isCompleted.toggle()
            }
            try? modelContext.save()
        } label: {

            HStack(alignment: .top, spacing: 16) {

                VStack {
                    Circle()
                        .fill(color)
                        .frame(width: 12, height: 12)

                    Rectangle()
                        .fill(color.opacity(0.25))
                        .frame(width: 2)
                }

                VStack(alignment: .leading, spacing: 8) {

                    HStack(spacing: 8) {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : icon)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(item.isCompleted ? moss : color)

                        Text(item.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(ink)
                            .strikethrough(item.isCompleted, color: stone)
                            .lineLimit(1)

                        Spacer()

                        Text(item.date.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.12))
                            .foregroundStyle(color)
                            .clipShape(Capsule())
                    }

                    if !item.location.isEmpty {
                        Label(item.location, systemImage: "mappin.and.ellipse")
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundStyle(stone)
                    }
                }
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
        .contextMenu {
            Button {
                showEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }

            Button(role: .destructive) {
                modelContext.delete(item)
                try? modelContext.save()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditItineraryItemSheet(item: item, ink: ink, sand: sand, clay: clay, stone: stone)
                .presentationDetents([.height(360)])
                .presentationDragIndicator(.visible)
        }
    }

    private var icon: String {
        switch item.type {
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

    private var color: Color {
        switch item.type {
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
}

// MARK: - Edit Sheet

private struct EditItineraryItemSheet: View {

    @Bindable var item: ItineraryItem
    let ink: Color
    let sand: Color
    let clay: Color
    let stone: Color

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 18) {
            Text("Edit Event")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(ink)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 6) {
                Text("TITLE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(stone)

                TextField("Event title", text: $item.title)
                    .font(.system(size: 15))
                    .padding(12)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("TIME")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(stone)

                DatePicker("", selection: $item.date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(clay)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("LOCATION")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(stone)

                TextField("Optional", text: $item.location)
                    .font(.system(size: 15))
                    .padding(12)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Button {
                try? modelContext.save()
                dismiss()
            } label: {
                Text("Save Changes")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(clay)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .background(sand.ignoresSafeArea())
    }
}

#Preview {

    let container = try! ModelContainer(
        for: ItineraryItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = container.mainContext

    let item = ItineraryItem(
        tripID: UUID(),
        title: "Flight to Goa",
        date: .now,
        type: "✈️ Flight",
        location: "Mumbai → Goa"
    )

    context.insert(item)

    return ItineraryRow(item: item)
        .padding()
        .modelContainer(container)

}
