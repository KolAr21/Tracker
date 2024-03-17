//
//  DataProvider.swift
//  Tracker
//
//  Created by Арина Колганова on 11.02.2024.
//

import Foundation
import CoreData

protocol DataProviderProtocol {
    var trackerCategories: [TrackerCategoryCoreData] { get }
    var selectWeekdays: [Weekday] { get }
    var selectCategory: String? { get }
    func addCategory(_ category: TrackerCategory) throws
    func updateTracker(trackerId: UUID)
}

final class DataProvider: NSObject {
    static let DidChangeCategoriesNotification = Notification.Name(rawValue: "CategoriesDidChange")
    static let DidChangeSelectItemsNotification = Notification.Name(rawValue: "SelectItemDidChange")

    private let context: NSManagedObjectContext
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    private let trackerRecordStore: TrackerRecordStore

    private(set) var selectWeekdays: [Weekday] = []
    private(set) var selectCategory: String?
    private(set) var selectFilter: Filters = .all

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
        self.trackerCategoryStore = TrackerCategoryStore(context: context)
        self.trackerRecordStore = TrackerRecordStore(context: context)
    }

    func fetchedTrackerRecord() -> [TrackerRecordCoreData] {
        trackerRecordStore.fetchTrackerRecord() ?? []
    }

    func updateWeekdays(newSelectWeekdays: [Weekday]) {
        selectWeekdays = newSelectWeekdays
        NotificationCenter.default.post(name: DataProvider.DidChangeSelectItemsNotification, object: self)
    }

    func updateFilter(filter: Filters) {
        selectFilter = filter
        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }

    func updateSelectCategory(newSelectCategory: String) {
        selectCategory = newSelectCategory
        NotificationCenter.default.post(name: DataProvider.DidChangeSelectItemsNotification, object: self)
    }

    func removeSelectItems() {
        selectCategory = nil
        selectWeekdays = []
    }

    // MARK: - Private methods

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

// MARK: - DataProviderProtocol

extension DataProvider: DataProviderProtocol {
    var trackerCategories: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }

    func addCategory(_ category: TrackerCategory) throws {
        let categoryCoreData =  trackerCategoryStore.addNewCategory(title: category.title)
        guard let tracker = category.trackersList.first else {
            categoryCoreData.trackers = NSSet()
            saveContext()
            return
        }

        let trackerCoreData = trackerStore.createTracker(tracker: tracker)
        categoryCoreData.addToTrackers(trackerCoreData)
        saveContext()
    }

    func addRecordTracker(_ record: TrackerRecord) throws {
        trackerRecordStore.addTrackerRecord(tracker: record)
        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }

    func deleteRecordTracker(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }

    func deleteTracker(_ trackerID: UUID) {
        trackerStore.deleteTracker(trackerID: trackerID)
    }

    func updateTracker(trackerId: UUID) {
        guard let trackerCoreData = trackerStore.findTracker(trackerId: trackerId) else {
            return
        }

        trackerCoreData.isFixed = !trackerCoreData.isFixed
        saveContext()

        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }

    func saveTracker(tracker: Tracker, category: String) {
        guard let trackerCoreData = trackerStore.findTracker(trackerId: tracker.id) else {
            return
        }

        trackerCoreData.category?.title = category
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        saveContext()

        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }
}
