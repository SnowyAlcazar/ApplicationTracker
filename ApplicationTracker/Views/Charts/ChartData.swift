//
//  ChartData.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 29/05/2024.
//

import Foundation

class Data: Identifiable {
    let type: String
    let val: Int
    
    var id: String { type }

    init(type: String = "", val: Int = 0) {
        self.type = type
        self.val = val
    }
}
