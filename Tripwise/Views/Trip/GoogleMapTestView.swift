//
//  GoogleMapTestView.swift
//  Tripwise
//
//  Created by sameer nimje on 03/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct GoogleMapTestView: UIViewRepresentable {

    func makeUIView(context: Context) -> GMSMapView {

        let camera = GMSCameraPosition.camera(
            withLatitude: 19.0760,
            longitude: 72.8777,
            zoom: 12
        )

        let mapView = GMSMapView(frame: .zero, camera: camera)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: 19.0760,
            longitude: 72.8777
        )
        marker.title = "Mumbai"
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) { }
}
