//
//  HotelsViewModel.swift
//  Tripwise
//
//  Created by sameer nimje on 30/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import Observation

@Observable
class HotelsViewModel {

    var hotels: [Hotel] = []

    func addHotel(_ hotel: Hotel) {
        hotels.append(hotel)
    }
}
