//
//  CreateTrackerCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class CreateTrackerCoordinator: BaseCoordinator<CreateTrackerCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        let controller = assembly.createTrackerVC()
        controller.openNewHabbit = { [weak controller] in
            let coordinator = self.assembly.newHabitCoordinator()
            guard let createTrackerVC = coordinator.make() else {
                return
            }
            controller?.present(createTrackerVC, animated: true)
        }
        return controller
    }
}
