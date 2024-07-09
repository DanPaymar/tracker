//
//  ContentView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftData
import MapKit

struct AddNewTrip: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var locationManager = LocationManager()
    
    @State var forecastListVM = ForecastListViewModel()
    @State private var places = [PlaceVM]()
    
    @State private var title: String = ""
    @State private var destination: String?
    @State private var searchText: String = ""
    
    // computed property to enusre all fields are entered before enabling save
    private var isValid: Bool {
        !title.isEmpty && destination != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Trip type", text: $title)
                
                if destination == nil {
                    HStack {
                        TextField("Your destination", text: $searchText)
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(.blue)
                    }
                    if !places.isEmpty {
                        List(places) { place in
                            Button(
                                action: {
                                    destination = place.placemarkTitle
                                    forecastListVM
                                        .getWeatherForecast(
                                            for: place.placemarkTitle
                                        )
                                }) {
                                    HStack {
                                        Image(systemName: "location.circle")
                                            .foregroundColor(.blue)
                                        Text(place.name)
                                    }
                                }
                        }
                        .listStyle(.plain)
                    }
                } else {
                    HStack {
                        Text(destination ?? "Nothing here so fix it")
                        Spacer()
                        Button {
                            searchText = ""
                            destination = nil
                            places.removeAll()
                            forecastListVM.forecasts = [] 
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("Add a trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let destination = destination else { return }
                        let trip = Trip(
                            title: title,
                            destination: destination
                            // tripDate: tripDate
                        )
                        
                        context.insert(trip)
                        
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
            .onChange(of: searchText) {
                search(text: searchText)
            }
        }
    }
    
    
    func search(text: String) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = locationManager.region
        
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
#Preview {
    AddNewTrip()
}
