//
//  BookDetailView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SwiftUI
import SwiftData

struct TripDetailView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    
    @State private var title: String = ""
    @State private var location: String = ""
    //    @State private var tripDate: Date
    
    @State private var showAddNewNote = false
    @State private var showAddNewGear = false
    
    init(trip: Trip) {
        self.trip = trip
        self._title = State(initialValue: trip.title)
        self._location = State(initialValue: trip.location)
        //        self._tripDate = State(initialValue: trip.tripDate)
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Title", text: $title)
                    TextField("Destination", text: $location)
                    //                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                }
                
                Button("Save") {
                    //                    guard let
                    trip.title = title
                    trip.location = location
                    
                    do {
                        try context.save()
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text(trip.title)
                Text(trip.location)
                //                Text(trip.tripDate.description)
            }
            
            Section("Gear") {
                Button(action: {
                    showAddNewGear.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                        Text("Add gear")
                    }
                }
                .sheet(isPresented: $showAddNewGear) {
                    NavigationStack {
                        AddNewGear(trip: trip)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .interactiveDismissDisabled()
                }
                if trip.gears.isEmpty {
                    ContentUnavailableView(
                        "Be prepared",
                        systemImage: "figure.strengthtraining.functional",
                        description: Text("Add some gear to bring on your adventure")
                    )
                } else {
                    GearListView(trip: trip)
                }
            }

            Section("Trip plan") {
                Button(action: {
                    showAddNewNote.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                        Text("Add note")
                    }
                }
                .sheet(isPresented: $showAddNewNote) {
                    NavigationStack {
                        AddNewNote(trip: trip)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .interactiveDismissDisabled()
                }
                
                if trip.notes.isEmpty {
                    ContentUnavailableView("No notes", systemImage: "pencil.and.list.clipboard")
                } else {
                    NotesListView(trip: trip)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Trip Detail")
    }
}

//#Preview {
//    BookDetailView()
//}
