//
//  searchResultsVM.swift
//  locationAutocomplete
//
//  Created by Daniel Paymar on 7/5/24.
//

import Foundation
import MapKit

@MainActor
class SearchResultsVM: ObservableObject {
    
    @Published var places = [PlaceVM]()
    
    func search(text: String, region: MKCoordinateRegion) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        // Set the result types to include addresses and points of interest
        searchRequest.resultTypes = [.address, .pointOfInterest]
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Filter the results to include only relevant points of interest
            self.places = response.mapItems
                .filter { mapItem in
                    mapItem.placemark.locality != nil ||
                    mapItem.pointOfInterestCategory == .nationalPark ||
                    mapItem.pointOfInterestCategory == .park ||
                    mapItem.pointOfInterestCategory == .beach ||
                    mapItem.pointOfInterestCategory == .campground ||
                    mapItem.pointOfInterestCategory == .hiking ||
                    mapItem.pointOfInterestCategory == .kayaking ||
                    mapItem.pointOfInterestCategory == .rockClimbing ||
                    mapItem.pointOfInterestCategory == .skiing ||
                    mapItem.pointOfInterestCategory == .surfing
                }
                .map(PlaceVM.init)
        }
    }
}


