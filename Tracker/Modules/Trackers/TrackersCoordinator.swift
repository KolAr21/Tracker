//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersCoordinator: BaseCoordinator<TrackersCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        let controller = assembly.trackerVC()
        controller.openCreateTracker = { [weak controller] in
            let coordinator = self.assembly.createTrackerCoordinator()
            guard let createTrackerVC = coordinator.make() else {
                return
            }

            let navVC = self.assembly.rootNavigationController(vc: createTrackerVC)
            controller?.navigationController?.present(navVC, animated: true)
        }

        controller.openEditHabitClosure = { [weak controller] model in
            let coordinator = self.assembly.newHabitCoordinator(
                parameters: [
                    NSLocalizedString("category.title", comment: "Text displayed on tracker"),
                    NSLocalizedString("schedule.title", comment: "Text displayed on tracker")
                ],
                model: model
            )
            guard let newHabitVC = coordinator.make() else {
                return
            }

            let navVC = self.assembly.rootNavigationController(vc: newHabitVC)
            controller?.navigationController?.present(navVC, animated: true)
        }
        controller.openFiltersClosure = {
            let coordinator = self.assembly.filtersCoordinator()
            guard let filterVC = coordinator.make() else {
                return
            }

            let navVC = self.assembly.rootNavigationController(vc: filterVC)
            controller.navigationController?.present(navVC, animated: true)
        }
        return controller
    }
}
