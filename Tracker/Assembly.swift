//
//  Assembly.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

final class Assembly {
    func appCoordinator() -> AppCoordinator {
        AppCoordinator(assembly: self, context: CoordinatorContext())
    }

    func rootTabBarController() -> UITabBarController {
        TabBarController()
    }

    func rootNavigationController() -> UINavigationController {
        let controller = UINavigationController()
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}
