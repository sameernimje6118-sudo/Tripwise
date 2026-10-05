//
//  ItineraryItem.swift
//  Tripwise
//
//  Created by sameer nimje on 02/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class ItineraryItem {

    @Attribute(.unique)
    var id: UUID

    var tripID: UUID
    var location: String
    var title: String
    var date: Date
    var type: String
    var isCompleted: Bool
    var isGenerated: Bool
    init(
        id: UUID = UUID(),
        tripID: UUID,
        title: String,
        date: Date,
        type: String,
        location: String = "",
        isCompleted: Bool = false,
        isGenerated: Bool = false
    ) {
        self.id = id
        self.tripID = tripID
        self.title = title
        self.date = date
        self.type = type
        self.location = location
        self.isCompleted = isCompleted
        self.isGenerated = isGenerated
    }
}
