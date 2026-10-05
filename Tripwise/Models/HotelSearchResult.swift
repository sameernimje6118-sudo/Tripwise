//
//  HotelSearchResult.swift
//  Tripwise
//
//  Created by sameer nimje on 01/07/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation

struct HotelSearchResult: Identifiable {

    let id: UUID
    let name: String
    let address: String
    let rating: Double?
 
    let latitude: Double
    let longitude: Double

}
