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
        assembly.categoryVC()
    }
}
