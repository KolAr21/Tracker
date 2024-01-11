//
//  SplashAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

protocol SplashAssembly {
    func splashCoordinator() -> SplashCoordinator
    func splashVC() -> SplashViewController<SplashViewImp>
}

extension Assembly: SplashAssembly {
    func splashCoordinator() -> SplashCoordinator {
        SplashCoordinator(assembly: self, context: .init())
    }

    func splashVC() -> SplashViewController<SplashViewImp> {
        .init()
    }
}
