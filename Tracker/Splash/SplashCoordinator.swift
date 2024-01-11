//
//  SplashCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

final class SplashCoordinator: BaseCoordinator<SplashCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.splashVC()
    }
}
