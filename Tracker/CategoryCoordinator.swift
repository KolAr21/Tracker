//
//  CategoryCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

final class CategoryCoordinator: BaseCoordinator<CategoryCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        let controller = assembly.categoryVC()
        controller.addNewCategoryClosure = { [weak controller] in
            let coordinator = self.assembly.newCategoryCoordinator()
            guard let newCategoryVC = coordinator.make() else {
                return
            }
            let navVC = self.assembly.rootNavigationController(vc: newCategoryVC)
            controller?.navigationController?.present(navVC, animated: true)
        }
        return controller
    }
}
