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
            controller?.present(createTrackerVC, animated: true)
        }
        return controller
    }
}
