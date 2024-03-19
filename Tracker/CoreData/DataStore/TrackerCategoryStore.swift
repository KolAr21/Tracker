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

    func addNewCategory(title: String) -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        let category = (try? context.fetch(request))?.first ?? TrackerCategoryCoreData(context: context)
        category.title = title
        return category
    }
}
