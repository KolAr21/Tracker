//
//  OnboardingCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 18.02.2024.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator<OnboardingCoordinator.Context> {
    struct Context {
        let onSuccess: (() -> Void)?
    }

    override func make() -> UIViewController? {
        assembly.onboardingVC(onSuccess: context.onSuccess)
    }
}
