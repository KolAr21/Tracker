//
//  Assembly.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit
import CoreData

final class Assembly {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Не удалось подключить хранилище")
                return
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    lazy var dataProvider: DataProvider = DataProvider(context: context)

    func appCoordinator() -> AppCoordinator {
        AppCoordinator(assembly: self, context: CoordinatorContext())
    }

    func rootTabBarController() -> UITabBarController {
        TabBarController()
    }

    func rootNavigationController(vc: UIViewController) -> UINavigationController {
        BaseNavigationController(rootViewController: vc)
    }
}
