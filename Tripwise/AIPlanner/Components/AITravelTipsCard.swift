//
//  AITravelTipsCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI


struct AITravelTipsCard: View {

    let tips: [String]

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)
    private let moss = Color(red: 0.42, green: 0.56, blue: 0.38)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Travel Tips")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text("AI Recommendations")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(ink)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 50, height: 50)

                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 12) {
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(moss)

                        Text(tip)
                            .font(.system(size: 13.5))
                            .foregroundStyle(stone)

                        Spacer(minLength: 0)
                    }
                }
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
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AITravelTipsCard(
            tips: [
                "Carry sunscreen and sunglasses.",
                "Reach the airport 2 hours before departure.",
                "Keep cash for local transport.",
                "Visit beaches early to avoid crowds.",
                "Stay hydrated throughout the day."
            ]
        )
        .padding()

    }

}
