//
//  Date.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 24/04/2024.
//

import Foundation
import SwiftUI

extension Date {
 
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
 
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }

    var formatDateFull : String {
        let myLocale = Locale(identifier: "en_GB")
        let df = DateFormatter()
        df.locale = myLocale
        df.dateStyle = .full
        df.timeStyle = .none
        return df.string(from: self)
    }
}

extension DatePicker {
    
        var minDate : Date {
//            let currentDate = Date()
//            var calendar = Calendar(identifier: .gregorian)
//            calendar.timeZone = .current
//            var components = DateComponents()
//            components.calendar = calendar
//            components.year = -5
//            guard let minimumDate = calendar.date(byAdding: components, to: currentDate) else {
//                return Date()
//            }
//            return minimumDate
            return .now.startOfDay
        }
        
        var maxDate : Date {
            let currentDate = Date()
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = .current
            var components = DateComponents()
            components.calendar = calendar
            components.month = 3
            guard let maximumDate = calendar.date(byAdding: components, to: currentDate) else {
                return Date()
            }
            return maximumDate.endOfDay
        }
}
