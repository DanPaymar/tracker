//
//  trackerApp.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import SwiftUI
import SwiftData

@main
struct trackerApp: App {
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .modelContainer(for: [Trip.self])
        }
    }
}
