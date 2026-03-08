//
//  Agent.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
//  Rebuilt for CloudKit compatibility.
//  Key changes:
//  - Removed CodingKeys (not needed with SwiftData @Model)
//  - agency relationship inverse is declared on the Agency side
//  - representedBy inverse kept here (Application.agent)
//

import Foundation
import SwiftData

@Model
final class Agent {

    var name: String = ""
    var officePhone: String = ""
    var mobilePhone: String = ""
    var email: String = ""
    var isFavorite: Bool = false
    var notes: String = ""

    // Current agency — optional because agents can be independent or between agencies.
    // The inverse (@Relationship) is declared on Agency.agents.
    // If an agent moves agency, update this pointer; historical Application records
    // remain correctly attributed to the agent (not the agency).
    var agency: Agency?

    @Relationship(deleteRule: .nullify, inverse: \Application.agent)
    var representedBy: [Application]? = []

    // MARK: - Init
    init(
        name: String = "",
        officePhone: String = "",
        mobilePhone: String = "",
        email: String = "",
        isFavorite: Bool = false,
        notes: String = ""
    ) {
        self.name = name
        self.officePhone = officePhone
        self.mobilePhone = mobilePhone
        self.email = email
        self.isFavorite = isFavorite
        self.notes = notes
    }
}

// MARK: - Preview helper
extension Agent {
    static var `default`: Agent {
        Agent(
            name: "Frank Lee",
            officePhone: "020 8565 0009",
            mobilePhone: "07700 556655",
            email: "f.lee@example.com"
        )
    }
}
