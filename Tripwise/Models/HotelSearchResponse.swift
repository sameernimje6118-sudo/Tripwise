//
//  HotelSearchResponse.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct HotelSearchResponse: Decodable {
    let features: [HotelFeature]
}

struct HotelFeature: Decodable {
    let properties: HotelProperties
}

struct HotelProperties: Codable {

    let name: String?

    let formatted: String?

    let lat: Double?

    let lon: Double?

}
