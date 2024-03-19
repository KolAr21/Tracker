//
//  NewHabitAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitAssembly {
    func newHabitCoordinator(parameters: [String], model: TrackerModel?) -> NewHabitCoordinator
    func newHabitVC(parameters: [String], model: TrackerModel?) -> NewHabitViewController<NewHabitViewImp>
}

extension Assembly: NewHabitAssembly {
    func newHabitCoordinator(parameters: [String], model: TrackerModel?) -> NewHabitCoordinator {
        NewHabitCoordinator(assembly: self, context: .init(parameters: parameters, model: model))
    }

    func newHabitVC(parameters: [String], model: TrackerModel?) -> NewHabitViewController<NewHabitViewImp> {
        .init(parameters: parameters, model: model, dataProvider: dataProvider)
    }
}
