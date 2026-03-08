//
//  Agency.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
//  Agency represents the recruitment firm an Agent works for.
//  Agents can move between agencies, so Agency has no direct link to
//  Applications — the correct traversal is Agency → agents → representedBy.
//
//  Removed: representedApplications (was misleading — would mis-attribute
//  applications if an agent moved agencies during a job search)
//

import Foundation
import SwiftData

@Model
final class Agency {

    var name: String = ""
    var isFavorite: Bool = false

    // An agency has many agents. Inverse declared on Agent.agency.
    @Relationship(deleteRule: .nullify, inverse: \Agent.agency)
    var agents: [Agent]? = []

    // MARK: - Computed
    var sortedAgents: [Agent] {
        (agents ?? []).sorted { $0.name < $1.name }
    }

    // MARK: - Init
    init(name: String = "", isFavorite: Bool = false) {
        self.name = name
        self.isFavorite = isFavorite
    }
}
