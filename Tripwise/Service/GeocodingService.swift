//
//  GeocodingService.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import CoreLocation

struct GeocodingService {

    func coordinates(for city: String) async throws -> CLLocationCoordinate2D {

        let geocoder = CLGeocoder()

        let places = try await geocoder.geocodeAddressString(city)

        guard let location = places.first?.location else {
            throw URLError(.badServerResponse)
        }

        return location.coordinate

    }

}
