//
//  WeatherResponse.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let current: CurrentWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let temperature_2m: Double
    let apparent_temperature: Double
    let relative_humidity_2m: Int
    let wind_speed_10m: Double
    let weather_code: Int
}

struct DailyWeather: Codable {
    let time: [String]
    let weather_code: [Int]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let precipitation_probability_max: [Int]
}

struct Daily: Identifiable {
    let id = UUID()
    let date: String
    let code: Int
    let max: Double
    let min: Double
    let rain: Int
}
