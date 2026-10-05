//
//  WeatherView.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI

struct WeatherView: View {

    let latitude: Double
    let longitude: Double
    let city: String

    @State private var weather: WeatherResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?

    let service = WeatherService()

    // MARK: - Palette (matches rest of app)

    private let ink = Color(red: 0.16, green: 0.15, blue: 0.14)
    private let sand = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let clay = Color(red: 0.80, green: 0.47, blue: 0.35)
    private let stone = Color(red: 0.55, green: 0.52, blue: 0.48)

    var body: some View {

        ZStack {

            sand.ignoresSafeArea()

            if isLoading {
                ProgressView("Loading Weather...")
                    .tint(clay)
            } else if let weather {
                ScrollView {
                    VStack(spacing: 24) {
                        currentWeatherHeader(weather)
                        infoCardsGrid(weather)
                        forecastSection(weather)
                    }
                    .padding()
                }
                .transition(.opacity)
            } else {
                errorState
            }
        }
        .navigationTitle("Weather")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .task {
            await loadWeather()
        }
        .animation(.easeInOut(duration: 0.3), value: weather == nil)
    }

    // MARK: - Error State

    private var errorState: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 90, height: 90)
                .overlay {
                    Image(systemName: "cloud.slash.fill")
                        .font(.system(size: 34, weight: .light))
                        .foregroundStyle(.red.opacity(0.85))
                }

            VStack(spacing: 6) {
                Text("Couldn't Load Weather")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink)

                Text(errorMessage ?? "Please check your connection and try again.")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button {
                Task { await loadWeather() }
            } label: {
                Text("Try Again")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 11)
                    .background(clay)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Load Weather

    func loadWeather() async {

        isLoading = true
        errorMessage = nil

        do {
            weather = try await service.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
        } catch {
            errorMessage = "We couldn't reach the weather service. Please try again."
            print("❌ Weather fetch error:", error)
        }

        isLoading = false
    }
}

// MARK: - Day Name Helper

/// Scoped fileprivate rather than a bare global func, since an unqualified
/// top-level `dayName` was one bad rename/collision away from clashing with
/// another same-named helper anywhere else in the project.
fileprivate func dayName(from dateString: String) -> String {

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    guard let date = formatter.date(from: dateString) else {
        return dateString
    }

    if Calendar.current.isDateInToday(date) {
        return "Today"
    }

    let output = DateFormatter()
    output.dateFormat = "EEE"

    return output.string(from: date)
}

// MARK: - Sections

private extension WeatherView {

    @ViewBuilder
    func currentWeatherHeader(_ weather: WeatherResponse) -> some View {

        VStack(spacing: 10) {

            ZStack {
                Circle()
                    .fill(clay.opacity(0.12))
                    .frame(width: 100, height: 100)

                Image(systemName: WeatherHelper.icon(for: weather.current.weather_code))
                    .font(.system(size: 48))
                    .foregroundStyle(clay)
            }
            .padding(.bottom, 4)

            Text(city)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(ink)

            Text("\(Int(weather.current.temperature_2m))°C")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(ink)

            Text(WeatherHelper.description(for: weather.current.weather_code))
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(stone)
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    func infoCardsGrid(_ weather: WeatherResponse) -> some View {

        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            weatherCard(icon: "thermometer.medium", title: "Feels Like", value: "\(Int(weather.current.apparent_temperature))°")
            weatherCard(icon: "humidity.fill", title: "Humidity", value: "\(weather.current.relative_humidity_2m)%")
            weatherCard(icon: "wind", title: "Wind", value: "\(Int(weather.current.wind_speed_10m)) km/h")
            weatherCard(icon: "calendar", title: "Forecast", value: "7 Days")
        }
    }

    @ViewBuilder
    func forecastSection(_ weather: WeatherResponse) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("7-Day Forecast")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(ink)

            VStack(spacing: 10) {
                ForEach(weather.daily.time.indices, id: \.self) { index in
                    forecastRow(weather, index: index)
                }
            }
        }
    }

    @ViewBuilder
    func forecastRow(_ weather: WeatherResponse, index: Int) -> some View {

        HStack {
            Text(dayName(from: weather.daily.time[index]))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(ink)
                .frame(width: 60, alignment: .leading)

            Spacer()

            Image(systemName: WeatherHelper.icon(for: weather.daily.weather_code[index]))
                .font(.system(size: 20))
                .foregroundStyle(clay)
                .frame(width: 40)

            Spacer()

            HStack(spacing: 4) {
                Text("\(Int(weather.daily.temperature_2m_max[index]))°")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(ink)

                Text("/")
                    .font(.system(size: 13))
                    .foregroundStyle(stone)

                Text("\(Int(weather.daily.temperature_2m_min[index]))°")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(stone)
            }
        }
        .padding(14)
        .weatherCardStyle()
    }

    @ViewBuilder
    func weatherCard(icon: String, title: String, value: String) -> some View {

        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(clay)

            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(ink)

            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(stone)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .weatherCardStyle()
    }
}

// MARK: - Card Style
// Replaces the old glassCard() (ultraThinMaterial + white overlay + shadow),
// which read as "frosted glass" and didn't match the solid white + hairline
// border card style used everywhere else in the app (ExpensesView, HotelsView, etc).

private extension View {

    @ViewBuilder
    func weatherCardStyle() -> some View {
        self
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
    }
}

#Preview {

    NavigationStack {

        WeatherView(
            latitude: 15.4909,
            longitude: 73.8278,
            city: "Goa"
        )

    }

}
