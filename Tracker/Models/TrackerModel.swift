//
//  TrackerModel.swift
//  Tracker
//
//  Created by Арина Колганова on 08.03.2024.
//

import Foundation

struct TrackerModel {
    let id: UUID
    let name: String
    let category: String
    let weekdays: [Weekday]
    let schedule: String
    let color: Int
    let emoji: Int
    let countDay: Int
}
