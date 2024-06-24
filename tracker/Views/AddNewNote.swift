//
//  AddNewNote.swift
//  tracker
//
//  Created by Daniel Paymar on 6/23/24.
//

import SwiftUI
import SwiftData


struct AddNewNote: View {
    let trip: Trip
    
    @State private var title = ""
    @State private var message = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    

    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Message", text: $message)
            
        }
        .navigationTitle("Add new note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let note = Note(title: title, message: message)
                    note.trip = trip
                    context.insert(note)
                    
                    do {
                        try context.save()
                        trip.notes.append(note)
                        
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
//    AddNewNote()
//}
