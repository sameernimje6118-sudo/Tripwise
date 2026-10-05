//
//  LocationManager.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var currentCity = "Unknown"

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.first else { return }

        CLGeocoder().reverseGeocodeLocation(location) { places, _ in

            DispatchQueue.main.async {
                self.currentCity = places?.first?.locality ?? "Unknown"
            }

        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}
