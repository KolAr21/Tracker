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
        let coordinator = assembly.splashCoordinator()
        setRoot(viewController: coordinator.make())
    }

    // MARK: - Private methods

    private func setRoot(viewController: UIViewController?) {
        guard let window, let viewController else {
            return
        }

        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
