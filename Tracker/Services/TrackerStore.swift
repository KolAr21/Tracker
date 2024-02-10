//
//  TrackerStore.swift
//  Tracker
//
//  Created by Арина Колганова on 10.02.2024.
//

import Foundation
import CoreData

final class TrackerStore {
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
}
