//
//  Samples.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 07/06/2024.
//

import Foundation

extension Application {
    static var yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)
    static var twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date.now)
    static var fourdayaAgo = Calendar.current.date(byAdding: .day, value: -4, to: Date.now)
    static var lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)
    static var twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date.now)
    static var threeWeeksAgo = Calendar.current.date(byAdding: .day, value: -21, to: Date.now)
    static var lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)
    static var nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date.now)

    static var sampleApps: [Application] {
        [
            Application(position: "Sample 1", businessSector: "Insurance", positionType: "Contract", remunerationType: "Daily", remunerationAmount: 600.0, employmentType: "Contract", iR35: "Outside", positionCommitment: "Full time", workstyle: "Remote", officeDays: "Occasionally", whereAdvertised: "Direct contact", dateApplied: lastWeek!, requiredSkills: "Some", requiredExperience: "Some", update: "", updatedAt: twoDaysAgo!, interviewDate: nextWeek!, interviewResult: "", notes: "", appStatus: "Open"),
            Application(position: "Sample 2", businessSector: "Insurance", positionType: "Contract", remunerationType: "Daily", remunerationAmount: 550.0, employmentType: "Contract", iR35: "Outside", positionCommitment: "Full time", workstyle: "Hybrid", officeDays: "Twice", whereAdvertised: "JobServe", dateApplied: lastWeek!, requiredSkills: "Some", requiredExperience: "Some", update: "", updatedAt: twoDaysAgo!, interviewDate: nextWeek!, interviewResult: "", notes: "", appStatus: "Open"),
            Application(position: "Sample 3", businessSector: "Insurance", positionType: "Contract", remunerationType: "Daily", remunerationAmount: 650.0, employmentType: "Contract", iR35: "Outside", positionCommitment: "Full time", workstyle: "Office", officeDays: "5 days", whereAdvertised: "LinkedIn", dateApplied: lastWeek!, requiredSkills: "Some", requiredExperience: "Some", update: "", updatedAt: twoDaysAgo!, interviewDate: nextWeek!, interviewResult: "", notes: "", appStatus: "Interview"),
            Application(position: "Sample 4", businessSector: "Insurance", positionType: "Contract", remunerationType: "Daily", remunerationAmount: 700.0, employmentType: "Contract", iR35: "Outside", positionCommitment: "Full time", workstyle: "Remote", officeDays: "Fully remote", whereAdvertised: "JobServe", dateApplied: lastWeek!, requiredSkills: "Some", requiredExperience: "Some", update: "", updatedAt: twoDaysAgo!, interviewDate: lastWeek!, interviewResult: "Unsuccessful", notes: "", appStatus: "Closed")
        ]
    }
}


extension Agent {
    static var sampleAgents: [Agent] {
        [
            Agent(name: "Agent 1", officePhone: "020 xxxx yyyy", mobilePhone: "+44 7xxx xxx xxx", email: "man.from@mfuncle.com", isFavorite: false, notes: ""),
            Agent(name: "Agent 2", officePhone: "020 xxxx yyyy", mobilePhone: "+44 7xxx xxx xxx", email: "idiot.kuriakin@kgb.com", isFavorite: true, notes: ""),
            Agent(name: "Agent 3", officePhone: "020 xxxx yyyy", mobilePhone: "+44 7xxx xxx xxx", email: "Napolean.solo@mfuncle.com", isFavorite: true, notes: ""),
            Agent(name: "Agent 4", officePhone: "020 xxxx yyyy", mobilePhone: "+44 7xxx xxx xxx", email: "thrush.meister@mfuncle.com", isFavorite: false, notes: "")
        ]
    }
}

extension Agency {
    static var sampleAgencies: [Agency] {
        [
            Agency(name: "Uncle", isFavorite: true),
            Agency(name: "Thrush", isFavorite: false)
        ]
    }
}

extension Client {
    static var sampleClients: [Client] {
        [
            Client(name: "CIA"),
            Client(name: "KGB"),
            Client(name: "Thrush")

        ]
    }
}

extension Interview {
    static var lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)
    static var nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date.now)
    static var startTime = Calendar.current.date(bySettingHour: 10, minute: 00, second: 00, of: nextWeek!)
    static var endTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 00, of: nextWeek!)

    static var sampleInterviews: [Interview] {
        [
            Interview(name: "1st grilling", interviewDate: nextWeek!, startTime: startTime!, endTime: endTime!, location: "Head Office", interviewer: "The CIA", result: "", notes: "", application: Application.sampleApps[2]),
            Interview(name: "Another grilling", interviewDate: nextWeek!, startTime: startTime!, endTime: endTime!, location: "Head Office", interviewer: "The KGB", result: "", notes: "", application: Application.sampleApps[1]),
            Interview(name: "Yet another grilling", interviewDate: nextWeek!, startTime: startTime!, endTime: endTime!, location: "Head Office", interviewer: "Thrush", result: "", notes: "", application: Application.sampleApps[3])
        ]
    }
}

extension Status {
    static var sampleStatuses: [Status] {
        [
            Status(name: "Open"),
            Status(name: "Interview"),
            Status(name: "Offer"),
            Status(name: "Acceptance"),
            Status(name: "Closed")
        ]
    }
}
