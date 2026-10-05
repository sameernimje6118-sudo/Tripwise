//
//  Expense.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class Expense {

    @Attribute(.unique)
    var id: UUID

    var tripID: UUID
    var title: String
    var amount: Double
    var category: String

    init(
        id: UUID = UUID(),
        tripID: UUID,
        title: String,
        amount: Double,
        category: String
    ) {
        self.id = id
        self.tripID = tripID
        self.title = title
        self.amount = amount
        self.category = category
    }
}
