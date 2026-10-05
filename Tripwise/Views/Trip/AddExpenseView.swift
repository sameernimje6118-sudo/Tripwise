//
//  AddExpenseView.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import SwiftData
// MARK: - Category Style

struct CategoryStyle {
    let icon: String
    let bg: Color
    let color: Color
}

// MARK: - AddExpenseView

struct AddExpenseView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTitleFocused: Bool

    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Food"
    let trip: Trip
    let categories = [
        "Food", "Hotel", "Transport",
        "Shopping", "Entertainment", "Other"
    ]

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    private let sage = Color(red: 0.51, green: 0.58, blue: 0.45)
    private let slateBlue = Color(red: 0.42, green: 0.51, blue: 0.62)
    private let plum = Color(red: 0.60, green: 0.48, blue: 0.55)

    private let quickAmounts: [Double] = [100, 500, 1000, 2000]

    /// Single source of truth for category -> icon/color. ExpensesView should
    /// use this exact mapping (see CategoryStyle.map) so a category always
    /// looks the same across both screens.
    private var categoryIcons: [String: CategoryStyle] {
        [
            "Food": CategoryStyle(
                icon: "fork.knife",
                bg: clay.opacity(0.12),
                color: clay
            ),
            "Hotel": CategoryStyle(
                icon: "bed.double.fill",
                bg: slateBlue.opacity(0.12),
                color: slateBlue
            ),
            "Transport": CategoryStyle(
                icon: "car.fill",
                bg: plum.opacity(0.12),
                color: plum
            ),
            "Shopping": CategoryStyle(
                icon: "bag.fill",
                bg: sage.opacity(0.12),
                color: sage
            ),
            "Entertainment": CategoryStyle(
                icon: "popcorn.fill",
                bg: clay.opacity(0.10),
                color: Color(red: 0.72, green: 0.55, blue: 0.30)
            ),
            "Other": CategoryStyle(
                icon: "ellipsis.circle.fill",
                bg: stone.opacity(0.12),
                color: stone
            )
        ]
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && Double(amount) != nil
    }

    private var selectedStyle: CategoryStyle {
        categoryIcons[category]!
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                sand.ignoresSafeArea()
                scrollContent
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarItems }
            .safeAreaInset(edge: .bottom) { saveButton }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTitleFocused = true
            }
        }
    }

    // MARK: - Scroll Content

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 22) {
                previewCard
                nameField
                amountField
                categoryGrid
                Spacer(minLength: 120)
            }
            .padding(20)
        }
    }

    // MARK: - Live Preview Card

    private var previewCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(selectedStyle.color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: selectedStyle.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(selectedStyle.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title.isEmpty ? "Expense name" : title)
                    .font(.system(size: 15.5, weight: .bold))
                    .foregroundStyle(ink)
                    .lineLimit(1)

                Text(category)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone)
            }

            Spacer()

            Text(amount.isEmpty ? "₹0" : formattedIndianCurrency(Double(amount) ?? 0))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .animation(.snappy, value: title)
        .animation(.snappy, value: amount)
        .animation(.snappy, value: category)
    }

    // MARK: - Name Field

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("EXPENSE NAME")

            HStack {
                Image(systemName: "text.cursor")
                    .foregroundStyle(stone)
                TextField("e.g. Lunch", text: $title)
                    .focused($isTitleFocused)
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

    // MARK: - Amount Field

    private var amountField: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("AMOUNT")

            HStack {
                Text("₹")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(clay)
                TextField("0", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .padding(15)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            }

            quickAmountChips
        }
    }

    private var quickAmountChips: some View {
        HStack(spacing: 8) {
            ForEach(quickAmounts, id: \.self) { value in
                let isSelected = Double(amount) == value

                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    withAnimation(.snappy) {
                        amount = String(Int(value))
                    }
                } label: {
                    Text("₹\(Int(value))")
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

    // MARK: - Category Grid

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("CATEGORY")

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(categories, id: \.self) { item in
                    categoryTile(for: item)
                }
            }
        }
    }

    private func categoryTile(for item: String) -> some View {
        let style = categoryIcons[item]!
        let selected = item == category

        return Button {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.spring(duration: 0.3)) {
                category = item
            }
        } label: {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(selected ? style.color.opacity(0.15) : style.bg)
                    .frame(width: 46, height: 46)
                    .overlay {
                        Image(systemName: style.icon)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(style.color)
                    }

                Text(item)
                    .font(.system(size: 12, weight: selected ? .semibold : .regular))
                    .foregroundStyle(selected ? style.color : stone)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(selected ? style.color.opacity(0.06) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        selected ? style.color.opacity(0.35) : Color.black.opacity(0.06),
                        lineWidth: selected ? 1.2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button {
            guard let value = Double(amount) else { return }

            let expense = Expense(
                tripID: trip.id,
                title: title,
                amount: value,
                category: category
            )
            modelContext.insert(expense)
            try? modelContext.save()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            dismiss()
        } label: {
            Label("Save Expense", systemImage: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? clay : stone.opacity(0.35))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: isFormValid ? clay.opacity(0.35) : .clear, radius: 14, x: 0, y: 6)
        }
        .disabled(!isFormValid)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
                .foregroundStyle(stone)
        }
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { isTitleFocused = false }
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .tracking(1.0)
            .foregroundStyle(stone)
            .padding(.leading, 4)
    }

    private func formattedIndianCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        let number = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return "₹\(number)"
    }
}

// MARK: - Preview

#Preview {
    AddExpenseView(
        trip: Trip(
            title: "Goa Vacation",
            destination: "Goa",
            startDate: Date(),
            endDate: Date(),
            budget: 50000
        )
    )
}
