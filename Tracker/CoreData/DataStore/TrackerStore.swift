//
//  TrackerStore.swift
//  Tracker
//
//  Created by Арина Колганова on 10.02.2024.
//

import Foundation
import CoreData

final class TrackerStore {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createTracker(tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.isFixed = tracker.isFixed
        return trackerCoreData
    }

    func findTracker(trackerId: UUID) -> TrackerCoreData?  {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", (\TrackerCoreData.id)._kvcKeyPathString!, trackerId as NSUUID)
        return try? context.fetch(request).first
    }

    func deleteTracker(trackerID: UUID) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@",
            (\TrackerCoreData.id)._kvcKeyPathString!,
            trackerID as NSUUID
        )

        guard let object = (try? context.fetch(request))?.first else {
            return
        }

        context.delete(object)
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
