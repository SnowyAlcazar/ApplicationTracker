//
//  ApplicationTrackerApp.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
/// Document code with cmd+opt+/ keypress
import SwiftUI
import SwiftData

@main
struct ApplicationTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Application.self)
    }
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        
    }
}
