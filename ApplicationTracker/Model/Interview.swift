//
//  Interview.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 18/04/2024.
//
//  Rebuilt for CloudKit compatibility.
//  Key changes:
//  - application relationship is optional in the init (CRITICAL FIX)
//    CloudKit instantiates models with no-argument init internally —
//    a non-optional relationship parameter would cause assertion failure
//  - Inverse is declared on Application.interviews side
//

import Foundation
import SwiftData

@Model
final class Interview {

    var name: String = ""
    var interviewDate: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date()
    var location: String = ""
    var interviewer: String = ""
    var result: String = ""
    var notes: String = ""

    // Inverse declared on Application.interviews via @Relationship(inverse: \Interview.application)
    var application: Application?

    // MARK: - Init
    // application is optional — CloudKit needs to be able to create instances
    // without pre-existing relationship data.
    init(
        name: String = "",
        interviewDate: Date = Date(),
        startTime: Date = Date(),
        endTime: Date = Date(),
        location: String = "",
        interviewer: String = "",
        result: String = "",
        notes: String = "",
        application: Application? = nil
    ) {
        self.name = name
        self.interviewDate = interviewDate
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.interviewer = interviewer
        self.result = result
        self.notes = notes
        self.application = application
    }
}
    
