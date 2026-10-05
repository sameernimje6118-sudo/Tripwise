//
//  WeatherHelper.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct WeatherHelper {

    static func description(for code: Int) -> String {

        switch code {

        case 0:
            return "Sunny"

        case 1:
            return "Mainly Clear"

        case 2:
            return "Partly Cloudy"

        case 3:
            return "Cloudy"

        case 45, 48:
            return "Fog"

        case 51, 53, 55:
            return "Drizzle"

        case 61, 63, 65:
            return "Rain"

        case 71, 73, 75:
            return "Snow"

        case 80, 81, 82:
            return "Rain Showers"

        case 95:
            return "Thunderstorm"

        default:
            return "Unknown"

        }

    }

    static func icon(for code: Int) -> String {

        switch code {

        case 0:
            return "sun.max.fill"

        case 1:
            return "sun.max"

        case 2:
            return "cloud.sun.fill"

        case 3:
            return "cloud.fill"

        case 45, 48:
            return "cloud.fog.fill"

        case 51, 53, 55:
            return "cloud.drizzle.fill"

        case 61, 63, 65:
            return "cloud.rain.fill"

        case 71, 73, 75:
            return "snow"

        case 80, 81, 82:
            return "cloud.heavyrain.fill"

        case 95:
            return "cloud.bolt.rain.fill"

        default:
            return "cloud"

        }

    }

}
