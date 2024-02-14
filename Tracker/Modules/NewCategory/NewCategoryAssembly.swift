//
//  NewCategoryAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 07.02.2024.
//

import UIKit

protocol NewCategoryAssembly {
    func newCategoryCoordinator() -> NewCategoryCoordinator
    func newCategoryVC() -> NewCategoryViewController<NewCategoryViewImp>
}

extension Assembly: NewCategoryAssembly {
    func newCategoryCoordinator() -> NewCategoryCoordinator {
        NewCategoryCoordinator(assembly: self, context: .init())
    }

    func newCategoryVC() -> NewCategoryViewController<NewCategoryViewImp> {
        .init(dataProvider: dataProvider)
    }
}
