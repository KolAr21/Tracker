//
//  Assembly.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

final class Assembly {
    lazy var trackerService: TrackersService = TrackersServiceImp()

    func appCoordinator() -> AppCoordinator {
        AppCoordinator(assembly: self, context: CoordinatorContext())
    }

    func rootTabBarController() -> UITabBarController {
        TabBarController()
    }

    func rootNavigationController(vc: UIViewController) -> UINavigationController {
        BaseNavigationController(rootViewController: vc)
    }
}
