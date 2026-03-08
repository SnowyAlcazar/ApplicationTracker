//
//  Client.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
//  Rebuilt for CloudKit compatibility.
//  Key changes:
//  - @Relationship on associatedApplications now declares inverse (CRITICAL FIX)
//    Previously missing — caused CloudKit assertion failure
//

import Foundation
import SwiftData

@Model
final class Client {

    var name: String = ""
    var businessSegment: String = ""
    var hiringManager: String = ""
    var hiringManagerPosition: String = ""

    // Inverse declared here — Application.client points back to this model.
    @Relationship(deleteRule: .nullify, inverse: \Application.client)
    var associatedApplications: [Application]? = []

    // MARK: - Init
    init(
        name: String = "",
        businessSegment: String = "",
        hiringManager: String = "",
        hiringManagerPosition: String = ""
    ) {
        self.name = name
        self.businessSegment = businessSegment
        self.hiringManager = hiringManager
        self.hiringManagerPosition = hiringManagerPosition
    }
}
