//
//  FiltersAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import UIKit

protocol FiltersAssembly {
    func filtersCoordinator() -> FiltersCoordinator
    func filtersVC() -> FiltersViewController<FiltersViewImp>

}

extension Assembly: FiltersAssembly {
    func filtersCoordinator() -> FiltersCoordinator {
        FiltersCoordinator(assembly: self, context: .init())
    }

    func filtersVC() -> FiltersViewController<FiltersViewImp> {
        .init(dataProvider: dataProvider)
    }
}
