//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Арина Колганова on 10.02.2024.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTrackerRecord() -> [TrackerRecordCoreData]? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        return try? context.fetch(fetchRequest)
    }

    func addTrackerRecord(tracker: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = tracker.id
        trackerRecordCoreData.date = tracker.date
        saveContext()
    }

    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            (\TrackerRecordCoreData.id)._kvcKeyPathString!,
            trackerRecord.id as NSUUID,
            #keyPath(TrackerRecordCoreData.date),
            trackerRecord.date as NSDate
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
