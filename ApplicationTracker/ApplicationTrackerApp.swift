//
//  ApplicationTrackerApp.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
//  Rebuilt for CloudKit compatibility.
//  Key changes:
//  - modelContainer now registers ALL six model types (previously only Application)
//    SwiftData/CloudKit requires every model in the schema to be declared upfront
//  - CloudKit database set to .automatic to enable iCloud sync
//  - Container built with explicit Schema + ModelConfiguration pattern
//    (same approach as ProjectAble v2.0)
//

import SwiftUI
import SwiftData

@main
struct ApplicationTrackerApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Application.self,
            Agency.self,
            Agent.self,
            Client.self,
            Interview.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
