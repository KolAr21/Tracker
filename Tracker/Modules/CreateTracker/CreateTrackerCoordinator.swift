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
        controller.openNewHabitClosure = { [weak controller] in
            let coordinator = self.assembly.newHabitCoordinator(
                parameters: [
                    NSLocalizedString("category.title", comment: "Text displayed on tracker"),
                    NSLocalizedString("schedule.title", comment: "Text displayed on tracker")
                ]
            )
            guard let newHabitVC = coordinator.make() else {
                return
            }

            controller?.navigationController?.pushViewController(newHabitVC, animated: true)
        }
        controller.openIrregularEventClosure = { [weak controller] in
            let coordinator = self.assembly.newHabitCoordinator(
                parameters: [
                    NSLocalizedString("category.title", comment: "Text displayed on tracker")
                ]
            )
            guard let newHabitVC = coordinator.make() else {
                return
            }

            controller?.navigationController?.pushViewController(newHabitVC, animated: true)
        }
        return controller
    }
}
