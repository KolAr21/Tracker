//
//  CategoryAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

protocol CategoryAssembly {
    func categoryCoordinator() -> CategoryCoordinator
    func categoryVC() -> CategoryViewController
    func categoryVM() -> CategoriesViewModel
}

extension Assembly: CategoryAssembly {
    func categoryCoordinator() -> CategoryCoordinator {
        CategoryCoordinator(assembly: self, context: .init())
    }

    func categoryVC() -> CategoryViewController {
        CategoryViewController(viewModel: categoryVM())
    }

    func categoryVM() -> CategoriesViewModel {
        .init(dataProvider: dataProvider)
    }
}
