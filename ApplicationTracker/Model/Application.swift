//
//  Application.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//

import Foundation
import SwiftData

@Model
final class Application {
    var position: String = ""
    var businessSector: String = ""
    var positionType: String = ""
    var remunerationType: String = ""
    var remunerationAmount: Double = 0
    var employmentType: String = ""
    var iR35: String = ""
    var positionCommitment: String = ""
    var workstyle: String = ""
    var officeDays: String = ""
    var whereAdvertised: String = ""
    var dateApplied: Date = Date.now
    var requiredSkills: String = ""
    var requiredExperience: String = ""
    var update: String = ""
    var updatedAt: Date = Date.now
    var interviewDate: Date = Date()
    var interviewResult: String = ""
    var notes: String = ""
    var appStatus: String = "Open"
    var agency: Agency?
    var agent: Agent?
    var client: Client?
    var status: Status?
    
    @Relationship(deleteRule: .cascade, inverse: \Interview.application)
    var interviews: [Interview]? = []
    
    var sortedInterviews: [Interview] {
        var si = Array(interviews!)
        si.sort(by: { $0.interviewDate < $1.interviewDate })
        return si
    }
    
    init(
        position: String = "",
        businessSector: String = "",
        positionType: String = "",
        remunerationType: String = "",
        remunerationAmount: Double = 0,
        employmentType: String = "",
        iR35: String = "",
        positionCommitment: String = "",
        workstyle: String = "",
        officeDays: String = "",
        whereAdvertised: String = "",
        dateApplied: Date = .now,
        requiredSkills: String = "",
        requiredExperience: String = "",
        update: String = "",
        updatedAt: Date = .now,
        interviewDate: Date = Date(),
        interviewResult: String = "",
        notes: String = "",
        appStatus: String = "Open"
    )
    {
        self.position = position
        self.businessSector = businessSector
        self.positionType = positionType
        self.remunerationType = remunerationType
        self.remunerationAmount = remunerationAmount
        self.employmentType = employmentType
        self.iR35 = iR35
        self.positionCommitment = positionCommitment
        self.workstyle = workstyle
        self.officeDays = officeDays
        self.whereAdvertised = whereAdvertised
        self.dateApplied = dateApplied
        self.requiredSkills = requiredSkills
        self.requiredExperience = requiredExperience
        self.update = update
        self.updatedAt = updatedAt
        self.interviewDate = interviewDate
        self.interviewResult = interviewResult
        self.notes = notes
        self.appStatus = appStatus
    }
    func update<T>(keyPath: ReferenceWritableKeyPath<Application, T>, to value: T) {
      self[keyPath: keyPath] = value
      updatedAt = .now
    }
}





