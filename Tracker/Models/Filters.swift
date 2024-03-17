//
//  Filters.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import Foundation

enum Filters: String, CaseIterable {
    case all
    case today
    case complete
    case uncomplete

    var rawValue: String {
        switch self {
        case .all:
            return NSLocalizedString("filters.all", comment: "Text displayed on tracker")
        case .today:
            return NSLocalizedString("filters.today", comment: "Text displayed on tracker")
        case .complete:
            return NSLocalizedString("filters.complete", comment: "Text displayed on tracker")
        case .uncomplete:
            return NSLocalizedString("filters.uncomplete", comment: "Text displayed on tracker")
        }
    }
}
