//
//  AddWeatherView.swift
//  tracker
//
//  Created by Daniel Paymar on 7/5/24.
//

import SwiftUI
import MapKit

struct AddWeatherView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = SearchResultsVM()
    
    @State private var search: String = ""
    
    var body: some View {
        VStack {
            List(vm.places) { place in
                HStack {
                    Image(systemName: "location.circle")
                        .foregroundColor(.blue)
                    Text(place.name)
                    
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Add weather")
        .searchable(text: $search)
        .onChange(of: search) { searchText in
            vm.search(text: searchText, region: locationManager.region)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
        }
    }
}
