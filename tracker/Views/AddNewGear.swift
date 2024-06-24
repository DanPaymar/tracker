//
//  AddNewGear.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import SwiftUI
import SwiftData


struct AddNewGear: View {
    let trip: Trip
    
    @State private var title = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        Form {
            TextField("Add some gear", text: $title)
        }
        .navigationTitle("Add gear")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let gear = Gear(title: title)
                    gear.trip = trip
                    context.insert(gear)
                    
                    do {
                        try context.save()
                        trip.gears.append(gear)
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
            }
        }
    }
}

//#Preview {
//    AddNewGear()
//}
