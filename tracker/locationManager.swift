//
//  locationManager.swift
//  locationAutocomplete
//
//  Created by Daniel Paymar on 7/5/24.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    @Published var location: CLLocation?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    
    // CLLocationManager allows access to the current location
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.location = location
                self?.region = MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: 5000,
                    longitudinalMeters: 5000
                )
            }
        }
}
