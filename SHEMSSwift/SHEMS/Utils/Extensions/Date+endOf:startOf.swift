//
//  Date+endOf:startOf.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 29/09/2024.
//

import Foundation

extension Date {
    // Year
    var startOfYear: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: self))!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfYear)!
    }
    
    // Month
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    var endOfMonth: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    // Week
    var startOfWeek: Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfWeek)!
    }
    
    // Day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    // Hour
    var startOfHour: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))!
    }
    
    var endOfHour: Date {
        var components = DateComponents()
        components.hour = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfHour)!
    }
}
