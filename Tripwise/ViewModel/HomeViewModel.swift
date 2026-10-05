//
//  HomeViewModel.swift
//  Tripwise
//
//  Created by sameer nimje on 28/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

@Observable
class HomeViewModel {
    var totalBudget: Double {
        trips.reduce(0) { $0 + $1.budget }
    }

    var upcomingTrips: Int {
        trips.filter { $0.startDate > Date() }.count
    }

    var totalSpent: Double {
        trips.reduce(0) { total, trip in
            total + trip.expenses.reduce(0) { $0 + $1.amount }
        }
    }
    var trips: [Trip] = []
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
}
