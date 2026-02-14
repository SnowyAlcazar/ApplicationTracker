//
//  StatusInitializer.swift
//  ApplicationTracker
//
//  Helper to ensure default statuses exist in database
//

import SwiftUI
import SwiftData

struct StatusInitializer {
    /// Call this once on app launch to create default statuses
    static func ensureDefaultStatuses(in context: ModelContext) {
        // Check if statuses already exist
        let descriptor = FetchDescriptor<Status>()
        let existingStatuses = (try? context.fetch(descriptor)) ?? []
        
        // If we already have statuses, don't create duplicates
        guard existingStatuses.isEmpty else {
            print("📋 Statuses already exist (\(existingStatuses.count) found)")
            return
        }
        
        print("📋 Creating default statuses...")
        
        let defaultStatuses = [
            "Open",
            "Interview",
            "On hold",
            "Offer",
            "Accepted",
            "Closed"
        ]
        
        for statusName in defaultStatuses {
            let status = Status(name: statusName)
            context.insert(status)
            print("   ✅ Created status: '\(statusName)'")
        }
        
        // Save the context
        do {
            try context.save()
            print("📋 Default statuses created successfully!")
        } catch {
            print("❌ Error saving statuses: \(error)")
        }
    }
}
