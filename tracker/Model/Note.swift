//
//  Note.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var message: String
    var trip: Trip?
    
    init(title: String, message: String, trip: Trip? = nil) {
        self.title = title
        self.message = message
        self.trip = trip
    }
}
