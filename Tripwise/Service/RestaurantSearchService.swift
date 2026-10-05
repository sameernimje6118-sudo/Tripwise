//
//  RestaurantSearchService.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct RestaurantSearchService {

    func searchRestaurants(in city: String) async throws -> [RestaurantSearchResult] {

        let (lat, lon) = try await fetchCoordinates(for: city)

        let urlString =
        "\(APIConstants.placesURL)?categories=catering.restaurant&filter=circle:\(lon),\(lat),50000&limit=20&apiKey=\(APIConstants.geoapifyAPIKey)"

        guard let url = URL(string: urlString) else {
            return []
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(
            RestaurantSearchResponse.self,
            from: data
        )

        return response.features.map { feature in

            RestaurantSearchResult(
                id: UUID(),
                name: feature.properties.name ?? "Restaurant",
                address: feature.properties.formatted ?? "No Address",
                rating: nil,
              
                latitude: feature.properties.lat ?? 0,
                longitude: feature.properties.lon ?? 0
            )

        }

    }

    private func fetchCoordinates(for city: String) async throws -> (Double, Double) {

        let query =
        city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city

        let urlString =
        "\(APIConstants.geocodingURL)?text=\(query)&apiKey=\(APIConstants.geoapifyAPIKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(
            HotelSearchResponse.self,
            from: data
        )

        guard let first = response.features.first else {
            throw URLError(.badServerResponse)
        }

        return (
            first.properties.lat ?? 0,
            first.properties.lon ?? 0
        )
    }

}
