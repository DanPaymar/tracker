//
//  MKCoordinateRegion+Extensions.swift
//  locationAutocomplete
//
//  Created by Daniel Paymar on 7/5/24.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    
    static func defaultRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D.init(latitude: 37.830362, longitude: -122.607242),
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )
    }
}
