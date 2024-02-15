//
//  NewHabitAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitAssembly {
    func newHabitCoordinator(parameters: [String]) -> NewHabitCoordinator
    func newHabitVC(parameters: [String]) -> NewHabitViewController<NewHabitViewImp>
}

extension Assembly: NewHabitAssembly {
    func newHabitCoordinator(parameters: [String]) -> NewHabitCoordinator {
        NewHabitCoordinator(assembly: self, context: .init(parameters: parameters))
    }

    func newHabitVC(parameters: [String]) -> NewHabitViewController<NewHabitViewImp> {
        .init(parameters: parameters, dataProvider: dataProvider)
    }
}
