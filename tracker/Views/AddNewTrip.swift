//
//  ContentView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SwiftUI
import SwiftData

struct AddNewTrip: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var location: String = ""
//    @State private var tripDate: Date
    
    // computed property to enusre all fields are entered before enabling save
    private var isValid: Bool {
        !title.isEmpty && !location.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Form {
                    TextField("Trip type", text: $title)
                    TextField("Your destination", text: $location)
//                    DatePicker(
//                        "Date", selection: $tripDate,
//                        displayedComponents: .date
//                    )
                }
                Spacer()
            }
            .navigationBarTitle("Add a trip")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
//                        guard let tripDate else { return }
                        let trip = Trip(
                            title: title,
                            location: location
//                            tripDate: tripDate
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
        }
        
    }
}

#Preview {
    AddNewTrip()
}
