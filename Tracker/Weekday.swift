//
//  Weekday.swift
//  Tracker
//
//  Created by Арина Колганова on 09.02.2024.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday

    var longName: String {
        Calendar.current.weekdaySymbols[self.rawValue]
    }

    var shortName: String {
        Calendar.current.shortWeekdaySymbols[self.rawValue]
    }
}
