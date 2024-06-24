//
//  BookListView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var context
    @Query private var trips: [Trip]
    @State private var presentAddNew = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(trips) { trip in
                    TripCellView(trip: trip)
                }
                .onDelete(perform: delete(indexSet:))
                
            }
            .navigationTitle("My trips")
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add trip", systemImage: "plus") {
                        presentAddNew.toggle()
                    }
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewTrip()
                    })
                }
            }
            .overlay {
                if trips.isEmpty {
                    ContentUnavailableView {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 88))
                        Text("Looks like you have no plans")
                            .font(.system(size: 22, weight: .medium))
                    } description: {
                        Text("press the '+' to add some fun")
                    }
//                    ContentUnavailableView(
//                        "It looks like you aren't going anywhere",
//                        systemImage: "figure.hiking",
//                        description: Text("press the '+' to add your adventures")
//                    )
                }
            }
        }
    }
    
    private func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            let trip = trips[index]
            context.delete(trip)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

#Preview {
    TripListView()
}
