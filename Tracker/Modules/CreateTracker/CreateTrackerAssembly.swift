//
//  CreateTrackerAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol CreateTrackerAssembly {
    func createTrackerCoordinator() -> CreateTrackerCoordinator
    func createTrackerVC() -> CreateTrackerViewController<CreateTrackerViewImp>
}

extension Assembly: CreateTrackerAssembly {
    func createTrackerCoordinator() -> CreateTrackerCoordinator {
        CreateTrackerCoordinator(assembly: self, context: .init())
    }

    func createTrackerVC() -> CreateTrackerViewController<CreateTrackerViewImp> {
        .init()
    }
}
