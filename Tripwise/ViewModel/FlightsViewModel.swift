//
//  FlightsViewModel.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import Observation
import SwiftUI

@Observable
class FlightsViewModel {

    var flights: [Flight] = []

    func addFlight(_ flight: Flight) {
        flights.append(flight)
    }

    func deleteFlight(at offsets: IndexSet) {
        flights.remove(atOffsets: offsets)
    }
}
