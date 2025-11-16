//
//  Agent.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//

import Foundation
import SwiftData

@Model
final class Agent: Identifiable {
    var name: String = ""
    var officePhone: String = ""
    var mobilePhone: String = ""
    var email: String = ""
    var isFavorite = false
    var notes: String = ""

    @Relationship(deleteRule: .nullify, inverse: \Application.agent) var representedBy: [Application]? = []
    var agency: Agency?

    enum CodingKeys: CodingKey {
        case name
        case officePhone
        case mobilePhone
        case email
        case isFavorite
        case notes
    }
    init(name: String = "", officePhone: String = "", mobilePhone: String = "", email: String = "", isFavorite: Bool = false, notes: String = "") {
        self.name = name
        self.officePhone = officePhone
        self.mobilePhone = mobilePhone
        self.email = email
        self.isFavorite = isFavorite
        self.notes = notes
    }
}
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
