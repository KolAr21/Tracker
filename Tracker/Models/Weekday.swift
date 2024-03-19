//
//  Weekday.swift
//  Tracker
//
//  Created by Арина Колганова on 09.02.2024.
//

import Foundation

enum Weekday: Int, CaseIterable, Codable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday

    var longName: String {
        (Calendar.current.weekdaySymbols[self.rawValue].first?.uppercased() ?? "") +
        Calendar.current.weekdaySymbols[self.rawValue].dropFirst()
    }

    var shortName: String {
        Calendar.current.shortWeekdaySymbols[self.rawValue]
    }
}
