//
//  GeocodingResponse.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct GeocodingResponse: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let properties: FeatureProperties
}

struct FeatureProperties: Codable {
    let lat: Double
    let lon: Double
}
