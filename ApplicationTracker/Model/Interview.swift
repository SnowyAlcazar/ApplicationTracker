//
//  Interview.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 18/04/2024.
//

import Foundation
import SwiftData

@Model
final class Interview: Identifiable {
    var name: String = ""
    var interviewDate: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date()
    var location: String = ""
    var interviewer: String = ""
    var result: String = ""
    var notes: String = ""
    var application: Application?
    
    init(name: String = "", interviewDate: Date = Date(), startTime: Date = Date(), endTime: Date = Date(), location: String = "", interviewer: String = "", result: String = "", notes: String = "", application: Application) {
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
    
