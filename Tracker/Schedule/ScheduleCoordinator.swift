//
//  ScheduleCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

final class ScheduleCoordinator: BaseCoordinator<ScheduleCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.scheduleVC()
    }
}
