//
//  NotesListView.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    let trip: Trip
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            ForEach(trip.notes) { note in
                VStack(alignment: .leading) {
                    Text(note.title)
                        .bold()
                    Text(note.message)
                }
            }
            .onDelete(perform: deleteNote(indexSet:))
        }
    }
    
    private func deleteNote(indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = trip.notes[index]
            context.delete(note)
            
            trip.notes.remove(atOffsets: indexSet)
            
            do {
                try context.save()
            } catch {
                print("Error deleting note: \(error)")
            }
        }
    }
}

//#Preview {
//    NotesListView()
//}
