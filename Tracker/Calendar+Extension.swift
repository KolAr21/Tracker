//
//  Calendar+Extension.swift
//  Tracker
//
//  Created by Арина Колганова on 20.01.2024.
//

import Foundation

extension Calendar {
    static func sortedWeekdays() -> [String] {
        var weekdays = Calendar.current.weekdaySymbols.dropFirst()
        let sunday = Calendar.current.weekdaySymbols[0]
        weekdays.append(sunday)
        return Array(weekdays)
    }

    static func sortedShortWeekdays() -> [String] {
        var weekdays = Calendar.current.shortWeekdaySymbols.dropFirst()
        let sunday = Calendar.current.shortWeekdaySymbols[0]
        weekdays.append(sunday)
        return Array(weekdays)
    }
}
