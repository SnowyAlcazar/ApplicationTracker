//
//  Status.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 16/05/2024.
//

import Foundation
import SwiftData

@Model
final class Status {
    var name: String = "Open"
    
    init(name: String = "Open") {
        self.name = name
    }
    
    @Relationship(deleteRule: .nullify, inverse: \Application.status) var applicationStatus: [Application]? = []

}
