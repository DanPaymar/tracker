//
//  PlaceVM.swift
//  tracker
//
//  Created by Daniel Paymar on 7/5/24.
//

import Foundation
import MapKit

struct PlaceVM: Identifiable {
    let id = UUID()
    private var mapItem: MKMapItem
    
    init(_ mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        return mapItem.name ?? ""
    }
    
    var locality: String {
        return mapItem.placemark.locality ?? ""
    }
    
    var pointOfInterestCategory: MKPointOfInterestCategory? {
        return mapItem.pointOfInterestCategory
    }
    
    var placemarkTitle: String {
        return mapItem.placemark.title ?? "No placemark title -- check placeVM"
    }
}
