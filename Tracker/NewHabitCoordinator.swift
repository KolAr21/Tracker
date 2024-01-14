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
        let controller = assembly.newHabitVC()
        controller.onOpenSchedule = { [weak controller] in
            let coordinator = self.assembly.scheduleCoordinator()
            guard let scheduleVC = coordinator.make() else {
                return
            }
            let navVC = self.assembly.rootNavigationController()
            navVC.setViewControllers([scheduleVC], animated: false)
            controller?.present(navVC, animated: true)
        }
        return controller
    }
}
