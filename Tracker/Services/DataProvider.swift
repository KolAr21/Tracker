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

    func updateSelectCategory(newSelectCategory: String) {
        selectCategory = newSelectCategory
        NotificationCenter.default.post(name: DataProvider.DidChangeSelectItemsNotification, object: self)
    }

    func removeSelectItems() {
        selectCategory = nil
        selectWeekdays = []
    }
}

// MARK: - DataProviderProtocol

extension DataProvider: DataProviderProtocol {
    var trackerCategories: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }

    func addCategory(_ category: TrackerCategory) throws {
        try trackerCategoryStore.addNewCategory(title: category.title, tracker: category.trackersList.first)
    }

    func addRecordTracker(_ record: TrackerRecord) throws {
        trackerRecordStore.addTrackerRecord(tracker: record)
    }

    func deleteRecordTracker(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(name: DataProvider.DidChangeCategoriesNotification, object: self)
    }
}
