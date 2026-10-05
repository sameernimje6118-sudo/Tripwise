//
//  AIWeatherCard.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct AIWeatherCard: View {

    let weather: AIWeather

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weather")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(stone)

                    Text(weather.condition)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(ink)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(clay.opacity(0.12))
                        .frame(width: 54, height: 54)

                    Image(systemName: weatherIcon())
                        .font(.system(size: 24))
                        .foregroundStyle(clay)
                }
            }

            Divider().overlay(Color.black.opacity(0.06))

            HStack(spacing: 12) {
                weatherBox(title: "Temperature", value: weather.temperature, icon: "thermometer")
                weatherBox(title: "Humidity", value: weather.humidity, icon: "humidity.fill")
            }

            Divider().overlay(Color.black.opacity(0.06))

            VStack(alignment: .leading, spacing: 8) {
                Label("AI Weather Advice", systemImage: "lightbulb.fill")
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(clay)

                Text(weather.advice)
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
    private func weatherBox(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(clay)

            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(stone)

            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(clay.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func weatherIcon() -> String {
        let condition = weather.condition.lowercased()

        if condition.contains("sun") { return "sun.max.fill" }
        if condition.contains("cloud") { return "cloud.fill" }
        if condition.contains("rain") { return "cloud.rain.fill" }
        if condition.contains("storm") { return "cloud.bolt.rain.fill" }
        if condition.contains("snow") { return "snowflake" }

        return "cloud.sun.fill"
    }
}

#Preview {

    ZStack {

        Color(red: 0.97, green: 0.95, blue: 0.92)
            .ignoresSafeArea()

        AIWeatherCard(
            weather: AIWeather(
                condition: "Partly Cloudy",
                temperature: "29°C",
                humidity: "72%",
                advice: "Carry sunglasses during the day and keep a light umbrella for the evening."
            )
        )
        .padding()

    }

}
