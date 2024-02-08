//
//  BaseCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

class BaseCoordinator<Context> {
    let assembly: Assembly
    let context: Context

    init(assembly: Assembly, context: Context) {
        self.assembly = assembly
        self.context = context
    }

    func make() -> UIViewController? {
        fatalError("This method is abstract")
    }
}
