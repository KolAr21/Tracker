//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Арина Колганова on 10.02.2024.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addNewCategory(title: String, tracker: Tracker?) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        let category = (try? context.fetch(request))?.first ?? TrackerCategoryCoreData(context: context)

        category.title = title

        guard let tracker else {
            category.title = title
            category.trackers = NSSet()
            saveContext()
            return
        }

        let trackerStore = TrackerStore(context: context)
        let newTracker = trackerStore.createTracker(tracker: tracker)
        category.addToTrackers(newTracker)
        saveContext()
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
}
