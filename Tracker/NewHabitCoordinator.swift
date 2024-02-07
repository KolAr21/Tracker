//
//  NewHabitCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class NewHabitCoordinator: BaseCoordinator<NewHabitCoordinator.Context> {
    struct Context {
        let parameters: [String]
    }

    override func make() -> UIViewController? {
        let controller = assembly.newHabitVC(parameters: context.parameters)
        controller.onOpenSchedule = { [weak controller] in
            let coordinator = self.assembly.scheduleCoordinator()
            guard let scheduleVC = coordinator.make() else {
                return
            }
            let navVC = self.assembly.rootNavigationController(vc: scheduleVC)
            controller?.navigationController?.present(navVC, animated: true)
        }
        controller.onOpenCategory = { [weak controller] in
            let coordinator = self.assembly.categoryCoordinator()
            guard let categoryVC = coordinator.make() else {
                return
            }
            let navVC = self.assembly.rootNavigationController(vc: categoryVC)
            controller?.navigationController?.present(navVC, animated: true)
        }
        return controller
    }
}
