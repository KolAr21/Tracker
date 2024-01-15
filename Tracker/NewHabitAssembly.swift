//
//  NewHabitAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitAssembly {
    func newHabitCoordinator() -> NewHabitCoordinator
    func newHabitVC() -> NewHabitViewController<NewHabitViewImp>
}

extension Assembly: NewHabitAssembly {
    func newHabitCoordinator() -> NewHabitCoordinator {
        NewHabitCoordinator(assembly: self, context: .init())
    }

    func newHabitVC() -> NewHabitViewController<NewHabitViewImp> {
        .init(trackerService: trackerService)
    }
}
