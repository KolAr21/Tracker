//
//  NewHabitCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class NewHabitCoordinator: BaseCoordinator<NewHabitCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.newHabitVC()
    }
}
