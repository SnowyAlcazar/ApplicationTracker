//
//  Client.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/03/2024.
//

import Foundation
import SwiftData

@Model
final class Client: Identifiable {
    var name: String = ""
    var businessSegment: String = ""
    var hiringManager: String = ""
    var hiringManagerPosition: String = ""
    var associatedApplications: [Application]? = []
    
    init(name: String = "", businessSegment: String = "", hiringManager: String = "", hiringManagerPosition: String = "") {
        self.name = name
        self.businessSegment = businessSegment
        self.hiringManager = hiringManager
        self.hiringManagerPosition = hiringManagerPosition
    }
}
