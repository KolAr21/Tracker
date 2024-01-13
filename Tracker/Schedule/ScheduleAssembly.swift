//
//  ScheduleAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

protocol ScheduleAssembly {
    func scheduleCoordinator() -> ScheduleCoordinator
    func scheduleVC() -> ScheduleViewController<ScheduleViewImp>
}

extension Assembly: ScheduleAssembly {
    func scheduleCoordinator() -> ScheduleCoordinator {
        ScheduleCoordinator(assembly: self, context: .init())
    }

    func scheduleVC() -> ScheduleViewController<ScheduleViewImp> {
        .init()
    }
}
