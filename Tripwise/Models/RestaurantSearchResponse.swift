//
//  RestaurantSearchResponse.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct RestaurantSearchResponse: Codable {
    let features: [RestaurantFeature]
}

struct RestaurantFeature: Codable {
    let properties: RestaurantProperties
}

struct RestaurantProperties: Codable {

    let name: String?
    let formatted: String?

    let lat: Double?
    let lon: Double?

}
