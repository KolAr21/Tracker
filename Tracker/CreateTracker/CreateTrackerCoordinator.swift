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
            guard let newHabitVC = coordinator.make() else {
                return
            }
            let navVC = self.assembly.rootNavigationController()
            navVC.setViewControllers([newHabitVC], animated: false)
            controller?.present(navVC, animated: true)
        }
        return controller
    }
}
