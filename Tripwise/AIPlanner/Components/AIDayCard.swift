//
//  AIDayCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIDayCard: View {

    let day: AIDay

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Day \(day.day)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(clay)

                    Text(day.title)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(ink)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 46, height: 46)

                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(spacing: 0) {
                ForEach(Array(day.activities.enumerated()), id: \.element.id) { index, activity in
                    activityRow(activity, isLast: index == day.activities.count - 1)
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

    @ViewBuilder
    private func activityRow(_ activity: AIActivity, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {

            VStack(spacing: 0) {
                Circle()
                    .fill(clay)
                    .frame(width: 12, height: 12)

                // Stretches to match the content column's real height instead
                // of a hardcoded value, so it doesn't fall short or overshoot
                // when a description wraps to multiple lines.
                if !isLast {
                    Rectangle()
                        .fill(clay.opacity(0.25))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(activity.time)
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundStyle(stone)

                HStack(spacing: 8) {
                    Image(systemName: icon(for: activity.type))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(clay)

                    Text(activity.title)
                        .font(.system(size: 14.5, weight: .bold))
                        .foregroundStyle(ink)
                }

                Text(activity.description)
                    .font(.system(size: 12.5))
                    .foregroundStyle(stone)

                HStack {
                    Label(activity.duration, systemImage: "clock.fill")
                    Spacer()
                    Label(activity.cost, systemImage: "indianrupeesign.circle.fill")
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(stone)
            }
            .padding(.bottom, isLast ? 0 : 18)

            Spacer()
        }
    }

    private func icon(for type: String) -> String {
        switch type.lowercased() {
        case "flight": return "airplane"
        case "hotel": return "bed.double.fill"
        case "checkin": return "bed.double.fill"
        case "checkout": return "rectangle.portrait.and.arrow.right"
        case "restaurant": return "fork.knife"
        case "breakfast": return "cup.and.saucer.fill"
        case "lunch": return "fork.knife"
        case "dinner": return "fork.knife"
        case "transport": return "car.fill"
        case "attraction": return "camera.fill"
        case "shopping": return "bag.fill"
        case "coffee": return "cup.and.saucer.fill"
        default: return "mappin.and.ellipse"
        }
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AIDayCard(
            day: AIDay(
                day: 1,
                title: "Arrival in Goa",
                activities: [

                    AIActivity(
                        time: "06:30 AM",
                        title: "Flight to Goa",
                        type: "flight",
                        description: "IndiGo 6E421",
                        duration: "1h 25m",
                        cost: "₹5,450"
                    ),

                    AIActivity(
                        time: "09:00 AM",
                        title: "Hotel Check-in",
                        type: "checkin",
                        description: "Vivanta Goa",
                        duration: "30 min",
                        cost: "Included"
                    ),

                    AIActivity(
                        time: "01:00 PM",
                        title: "Lunch",
                        type: "restaurant",
                        description: "Gunpowder Restaurant, known for its long-standing seafood thali and slow-cooked Goan curries overlooking the beach.",
                        duration: "1 hour",
                        cost: "₹900"
                    ),

                    AIActivity(
                        time: "03:00 PM",
                        title: "Fort Aguada",
                        type: "attraction",
                        description: "Explore the fort and sunset viewpoint.",
                        duration: "2 hours",
                        cost: "₹100"
                    )

                ]
            )
        )
        .padding()

    }

}
