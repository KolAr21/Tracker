//
//  OnboardingAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 18.02.2024.
//

import UIKit

protocol OnboardingAssembly {
    func onboardingCoordinator(onSuccess: (() -> Void)?) -> OnboardingCoordinator
    func onboardingVC(onSuccess: (() -> Void)?) -> OnboardingViewController
}

extension Assembly: OnboardingAssembly {
    func onboardingCoordinator(onSuccess: (() -> Void)?) -> OnboardingCoordinator {
        OnboardingCoordinator(assembly: self, context: .init(onSuccess: onSuccess))
    }

    func onboardingVC(onSuccess: (() -> Void)?) -> OnboardingViewController {
        .init(onSuccess: onSuccess)
    }
}
