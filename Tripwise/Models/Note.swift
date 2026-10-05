//
//  Note.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Note {

    @Attribute(.unique)
    var id: UUID

    var tripID: UUID
    var title: String
    var content: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        tripID: UUID,
        title: String,
        content: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.tripID = tripID
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
