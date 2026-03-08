//
//  Application.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//
//  Rebuilt for CloudKit compatibility.
//  Key changes:
//  - All attributes have default values (CloudKit requirement)
//  - sortedInterviews uses nil-safe guard (no force unwrap)
//  - Inverse relationships are declared on Agency and Client sides
//

import Foundation
import SwiftData

@Model
final class Application {

    // MARK: - Job Details
    var position: String = ""
    var businessSector: String = ""
    var positionType: String = ""
    var employmentType: String = ""
    var dateApplied: Date = Date.now
    var whereAdvertised: String = ""
    var requiredSkills: String = ""
    var requiredExperience: String = ""

    // MARK: - Pay & Conditions
    var remunerationType: String = ""
    var remunerationAmount: Double = 0
    var iR35: String = ""
    var positionCommitment: String = ""
    var workstyle: String = ""
    var officeDays: String = ""

    // MARK: - Umbrella (Inside IR35)
    var umbrellaCompanyName: String = ""
    var umbrellaContactName: String = ""
    var umbrellaContactPhone: String = ""
    var umbrellaContactEmail: String = ""

    // MARK: - Updates & Notes
    var update: String = ""
    var updatedAt: Date = Date.now
    var notes: String = ""

    // MARK: - Status
    // appStatus stored as String for use in #Predicate filters and sort descriptors.
    // Keep in sync with the status relationship via onChange in views.
    var appStatus: String = "Open"

    // MARK: - Relationships
    // All optional — CloudKit cannot guarantee relationship presence at fetch time.
    //
    // No direct agency stored — use agent?.agency instead.
    // This correctly handles agents moving between agencies without orphaning
    // historical application records.
    var agent: Agent?
    var client: Client?

    @Relationship(deleteRule: .cascade, inverse: \Interview.application)
    var interviews: [Interview]? = []

    // MARK: - Computed
    // Agency is derived — never stored directly on Application.
    var agency: Agency? { agent?.agency }

    var sortedInterviews: [Interview] {
        guard let interviews else { return [] }
        return interviews.sorted { $0.interviewDate < $1.interviewDate }
    }

    // MARK: - Init
    init(
        position: String = "",
        businessSector: String = "",
        positionType: String = "",
        employmentType: String = "",
        dateApplied: Date = .now,
        whereAdvertised: String = "",
        requiredSkills: String = "",
        requiredExperience: String = "",
        remunerationType: String = "",
        remunerationAmount: Double = 0,
        iR35: String = "",
        positionCommitment: String = "",
        workstyle: String = "",
        officeDays: String = "",
        umbrellaCompanyName: String = "",
        umbrellaContactName: String = "",
        umbrellaContactPhone: String = "",
        umbrellaContactEmail: String = "",
        update: String = "",
        updatedAt: Date = .now,
        notes: String = "",
        appStatus: String = "Open"
    ) {
        self.position = position
        self.businessSector = businessSector
        self.positionType = positionType
        self.employmentType = employmentType
        self.dateApplied = dateApplied
        self.whereAdvertised = whereAdvertised
        self.requiredSkills = requiredSkills
        self.requiredExperience = requiredExperience
        self.remunerationType = remunerationType
        self.remunerationAmount = remunerationAmount
        self.iR35 = iR35
        self.positionCommitment = positionCommitment
        self.workstyle = workstyle
        self.officeDays = officeDays
        self.umbrellaCompanyName = umbrellaCompanyName
        self.umbrellaContactName = umbrellaContactName
        self.umbrellaContactPhone = umbrellaContactPhone
        self.umbrellaContactEmail = umbrellaContactEmail
        self.update = update
        self.updatedAt = updatedAt
        self.notes = notes
        self.appStatus = appStatus
    }
}





