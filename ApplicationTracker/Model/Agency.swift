//
//  Agency.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//

import Foundation
import SwiftData

@Model
final class Agency: Identifiable {
    var name: String = ""
    var agents: [Agent]? = []
    var sortedAgents: [Agent] {
        var sa = Array(agents!)
        sa.sort(by: { $0.name < $1.name })
        return sa
    }
    
    var representedApplications: [Application]? = []
    var isFavorite = false
    
    init(name: String = "", isFavorite: Bool = false) {
        self.name = name
        self.isFavorite = isFavorite
    }
}
