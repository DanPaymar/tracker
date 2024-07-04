//
//  TripDetailView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//
import SDWebImageSwiftUI
import SwiftUI
import SwiftData

struct TripDetailView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var forecastListVM = ForecastListViewModel()
    
    @State private var isEditing = false
    
    @State private var title: String = ""
    @State private var destination: String = ""
    //    @State private var tripDate: Date
    
    @State private var showAddNewNote = false
    @State private var showAddNewGear = false
    
    init(trip: Trip) {
        self.trip = trip
        self._title = State(initialValue: trip.title)
        self._destination = State(initialValue: trip.destination)
        
        //        self._tripDate = State(initialValue: trip.tripDate)
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Title", text: $title)
                    TextField("Destination", text: $destination)
                    //                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                    
                }
                
                Button("Save") {
                    //                    guard let
                    trip.title = title
                    trip.destination = destination
                    
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
                Text(trip.destination)
                //                Text(trip.tripDate.description)
            }
            
            Section("\(destination) forecast") {
                Button {
                    forecastListVM.getWeatherForecast()
                } label: {
                    HStack {
                        TextField("Your destination", text: $forecastListVM.location)
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
                
                if forecastListVM.forecasts.isEmpty {
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
//                                    .frame(width: 200)
                                }
                            }
                            .onAppear {
                                scrollView.scrollTo(forecastListVM.forecasts.first?.day, anchor: .center)
                            }
                        }
                    }
                    .frame(height: 200)
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
    }
    
}


//#Preview {
//    BookDetailView()
//}
