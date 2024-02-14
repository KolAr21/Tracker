//
//  NewCategoryCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 07.02.2024.
//

import UIKit

final class NewCategoryCoordinator: BaseCoordinator<NewCategoryCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.newCategoryVC()
    }
}
