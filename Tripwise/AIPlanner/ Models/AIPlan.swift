//
//  AIPlan.swift
//  Tripwise
//
//  Created by sameer nimje on 08/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class AIPlan {

    var title: String
    var destination: String
    var createdAt: Date
    var trip: AITrip

    init(
        title: String,
        destination: String,
        trip: AITrip
    ) {
        self.title = title
        self.destination = destination
        self.trip = trip
        self.createdAt = Date()
    }

}
