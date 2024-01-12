//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

struct CoordinatorContext {}

final class AppCoordinator: BaseCoordinator<CoordinatorContext> {
    private var window: UIWindow?

    func start(window: UIWindow?) {
        self.window = window
        let coordinator = assembly.splashCoordinator { [weak self] in
            self?.setTabVC()
        }
        setRoot(viewController: coordinator.make())
    }

    // MARK: - Private methods

    private func setTabVC() {
        let tabVC = assembly.rootTabBarController()
        let trackerCoordinator = assembly.trackerCoordinator()

        guard let trackerVC = trackerCoordinator.make() else {
            return
        }

        let navVC = assembly.rootNavigationController()
        navVC.setViewControllers([trackerVC], animated: false)
        navVC.tabBarItem = RootTab.tracker.tabBarItem
        tabVC.setViewControllers([navVC], animated: false)
        setRoot(viewController: tabVC)
    }

    private func setRoot(viewController: UIViewController?) {
        guard let window, let viewController else {
            return
        }

        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
