//
//  GearListView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import SwiftUI
import SwiftData

struct GearListView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            ForEach(trip.gears) { gear in
                VStack(alignment: .leading) {
                    Text(gear.title)
                        .bold()
                    
                }
            }
            .onDelete(perform: deleteNote(indexSet:))
        }
    }
    
    private func deleteNote(indexSet: IndexSet) {
        indexSet.forEach { index in
            let gear = trip.gears[index]
            context.delete(gear)
            
            trip.gears.remove(atOffsets: indexSet)
            
            do {
                try context.save()
            } catch {
                print("Error deleting gear: \(error)")
            }
        }
    }
}

//#Preview {
//    GearListView()
//}
