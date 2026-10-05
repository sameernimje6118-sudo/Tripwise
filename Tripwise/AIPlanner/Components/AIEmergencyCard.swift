//
//  AIEmergencyCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//


import SwiftUI

struct AIEmergencyCard: View {

    let emergency: AIEmergency

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    // Emergency numbers keep red rather than the app's clay accent —
    // red is a near-universal "this matters right now" signal and shouldn't
    // be diluted to match the rest of the UI just for brand consistency.
    private let emergencyRed = Color(red: 0.82, green: 0.25, blue: 0.22)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Emergency")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text("Important Numbers")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(ink)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(emergencyRed.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(emergencyRed)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 10) {
                emergencyRow(icon: "shield.fill", title: "Police", number: emergency.police)
                emergencyRow(icon: "cross.fill", title: "Ambulance", number: emergency.ambulance)
                emergencyRow(icon: "phone.fill", title: "Tourist Helpline", number: emergency.touristHelpline)
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 8) {
                Label("AI Advice", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(clay)

                Text("Save these numbers before your trip. If traveling internationally, also keep your embassy contact details and travel insurance information accessible.")
                    .font(.system(size: 12.5))
                    .foregroundStyle(stone)
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
    private func emergencyRow(icon: String, title: String, number: String) -> some View {
        Button {
            call(number)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(emergencyRed.opacity(0.1))
                        .frame(width: 34, height: 34)

                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(emergencyRed)
                }

                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(ink)

                Spacer()

                Text(number)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(emergencyRed)

                Image(systemName: "phone.arrow.up.right.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(stone.opacity(0.6))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(emergencyRed.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    /// Strips anything that isn't a digit or + before dialing, since AI-generated
    /// numbers sometimes come formatted with spaces or dashes (e.g. "100" is fine,
    /// but a real embassy number might arrive as "+91 832 123 4567").
    private func call(_ number: String) {
        let digits = number.filter { $0.isNumber || $0 == "+" }
        guard !digits.isEmpty, let url = URL(string: "tel://\(digits)") else { return }

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIApplication.shared.open(url)
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AIEmergencyCard(
            emergency: AIEmergency(
                police: "100",
                ambulance: "108",
                touristHelpline: "1363"
            )
        )
        .padding()

    }

}
