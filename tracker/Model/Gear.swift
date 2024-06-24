//
//  Gear.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import Foundation
import SwiftData

@Model
final class Gear {
    var title: String
    var trip: Trip?
    
    init(title: String, trip: Trip? = nil) {
        self.title = title
        self.trip = trip
    }
}
