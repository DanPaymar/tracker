//
//  TripDetailView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//
import SwiftData
import SDWebImageSwiftUI
import MapKit
import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var forecastListVM = ForecastListViewModel()
    
//    @State private var search: String = ""
    
    @State private var isEditing = false
    
    @State private var title: String = ""
    @State private var destination: String = ""
    
    @State private var showAddNewNote = false
    @State private var showAddNewGear = false
    @State private var showAddWeather = false
    
    init(trip: Trip) {
        self.trip = trip
        self._title = State(initialValue: trip.title)
        self._destination = State(initialValue: trip.destination)
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Title", text: $title)
                    TextField("Destination", text: $destination)
                }
                
                Button("Save") {
                    trip.title = title
                    trip.destination = destination
                    
                    do {
                        try context.save()
                        forecastListVM.location = destination
                        forecastListVM.getWeatherForecast(for: destination)
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text(trip.title)
                Text(trip.destination)
            }
            
            Section("\(trip.destination) forecast") {
                VStack(alignment: .leading) {
                    if trip.destination.isEmpty {
                        VStack {
                            ContentUnavailableView(
                                "Add a destination to get the weather",
                                systemImage: "sun.max.trianglebadge.exclamationmark",
                                description: Text("Add a destination to get the weather")
                            )
                        }
                    } else {
                        ScrollView(.horizontal) {
                            ScrollViewReader { scrollView in
                                LazyHStack(spacing: 20) {
                                    ForEach(forecastListVM.forecasts, id: \.day) { day in
                                        VStack(alignment: .center) {
                                            Text(day.day)
                                                .fontWeight(.bold)
                                            HStack {
                                                Text(day.high)
                                                Text(day.low)
                                            }
                                            Text(day.overview)
                                                .font(.caption)
                                            WebImage(url: day.weatherIconURL)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 75)
                                            HStack {
                                                Text(day.clouds)
                                                Text(day.pop)
                                            }
                                            Text(day.humidity)
                                            
                                        }
                                        .id(day.day)
                                        .frame(width: 200)
                                    }
                                }
                                .onAppear {
                                    scrollView.scrollTo(forecastListVM.forecasts.first?.day, anchor: .center)
                                }
                            }
                        }
                    }
                }
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
                    ContentUnavailableView(
                        "Just winging it?",
                        systemImage: "pencil.and.list.clipboard",
                        description: Text("add a plan")
                    )
                } else {
                    NotesListView(trip: trip)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Trip Detail")
        .onAppear {
            if !trip.destination.isEmpty {
                forecastListVM.location = trip.destination
                forecastListVM.getWeatherForecast(for: destination)
            }
        }
    }
}


//#Preview {
//    BookDetailView()
//}
