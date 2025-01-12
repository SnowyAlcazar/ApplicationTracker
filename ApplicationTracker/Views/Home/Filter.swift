//
//  Filter.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 20/04/2024.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var addedDate = Date.distantPast
    
    static var allOpen = Filter(id: UUID(), name: "All open applications", icon: "tray")
    static var allClosed = Filter(id: UUID(), name: "All closed applications", icon: "curtains.closed")
    static var recent = Filter(id: UUID(), name: "Recently changed", icon: "clock", addedDate: .now.addingTimeInterval(86400 * -7))
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
