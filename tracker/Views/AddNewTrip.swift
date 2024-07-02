//
//  ContentView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//
import SDWebImageSwiftUI
import SwiftUI
import SwiftData

struct AddNewTrip: View {
   
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    //    @State var forecastListVM = ForecastListViewModel()
    
    @State private var title: String = ""
    @State private var destination: String = ""
    //    @State private var tripDate: Date
    
    // computed property to enusre all fields are entered before enabling save
    private var isValid: Bool {
        !title.isEmpty && !destination.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Trip type", text: $title)
                HStack {
                    TextField("Your destination", text: $destination)
                    Image(systemName: "magnifyingglass.circle.fill")
                        .foregroundColor(.blue)
                }
                // DatePicker("Date", selection: $tripDate, displayedComponents: .date)
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
        }
    }
}
#Preview {
    AddNewTrip()
}
