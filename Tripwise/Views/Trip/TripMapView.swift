//
//  TripMapView.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData

struct TripMapView: View {

    let trip: Trip

    @Query private var hotels: [Hotel]
    @Query private var attractions: [Attraction]

    @State private var cameraPosition: MapCameraPosition = .automatic

    var tripHotels: [Hotel] {
        hotels.filter { $0.tripID == trip.id }
    }

    var tripAttractions: [Attraction] {
        attractions.filter { $0.tripID == trip.id }
    }

    var body: some View {

        MapKit.Map(position: $cameraPosition) {

            // Hotels
            ForEach(tripHotels) { hotel in
                Marker(
                    hotel.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: hotel.latitude,
                        longitude: hotel.longitude
                    )
                )
                .tint(.blue)
            }

            // Attractions
            ForEach(tripAttractions) { attraction in
                Marker(
                    attraction.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: attraction.latitude,
                        longitude: attraction.longitude
                    )
                )
                .tint(.green)
            }

        }
        .navigationTitle("Trip Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: trip.latitude,
                        longitude: trip.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.08,
                        longitudeDelta: 0.08
                    )
                )
            )

        }
    }
}
#Preview {

    NavigationStack {

        TripMapView(
            trip: Trip(
                title: "Goa Trip",
                destination: "Goa",
                startDate: .now,
                endDate: .now,
                budget: 50000,
                latitude: 15.2993,
                longitude: 74.1240
            )
        )
        .modelContainer(
            for: [
                Trip.self,
                Hotel.self,
                Attraction.self
            ],
            inMemory: true
        )

    }

}
