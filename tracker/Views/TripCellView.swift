//
//  TripCellView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SwiftUI

struct TripCellView: View {
    let trip: Trip
    
    var body: some View {
        NavigationLink(value: trip) {
            VStack(alignment: .leading) {
                Text(trip.title)
                    .font(.headline)
                HStack {
                    Text(trip.destination)
                    Spacer()
                    
//                    Text("Date: \(trip.tripDate.description)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 20)
            }
        }
       
    }
}

//#Preview {
//    TripCellView()
//}
