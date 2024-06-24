//
//  Book.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import Foundation
import SwiftData

@Model
final class Trip {
    var title: String
    var location: String
//    var tripDate: Date
    
    // deletes notes associated within the trip
    @Relationship(deleteRule: .cascade, inverse:  \Note.trip)
    var notes = [Note]()
    // delete gear associated within the trip
    @Relationship(deleteRule: .cascade, inverse:  \Gear.trip)
    var gears = [Gear]()
    
    
   init(title: String, location: String) {
        self.title = title
        self.location = location
//        self.tripDate = tripDate
    }
}
