//
//  Trip.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import CoreLocation
import Foundation
import SwiftData

@Model
final class Trip {
    var title: String
    var destination: String
//    var tripDate: Date
  

    // deletes notes associated within the trip
    @Relationship(deleteRule: .cascade, inverse:  \Note.trip)
    var notes = [Note]()
    // delete gear associated within the trip
    @Relationship(deleteRule: .cascade, inverse:  \Gear.trip)
    var gears = [Gear]()
    
    @Relationship(deleteRule: .cascade, inverse: \Forecast.trip)
    var forecasts = [Forecast]()
    
    init(title: String, destination: String) {
        self.title = title
        self.destination = destination
//        self.tripDate = tripDate
    }
    
    
    
}

