//
//  SplashAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

protocol SplashAssembly {
    func splashCoordinator(onSuccess: (() -> Void)?) -> SplashCoordinator
    func splashVC(onSuccess: (() -> Void)?) -> SplashViewController<SplashViewImp>
}

extension Assembly: SplashAssembly {
    func splashCoordinator(onSuccess: (() -> Void)?) -> SplashCoordinator {
        SplashCoordinator(assembly: self, context: .init(onSuccess: onSuccess))
    }

    func splashVC(onSuccess: (() -> Void)?) -> SplashViewController<SplashViewImp> {
        .init(onSuccess: onSuccess)
    }
}
