//
//  FiltersCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import UIKit

final class FiltersCoordinator: BaseCoordinator<FiltersCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.filtersVC()
    }
}
