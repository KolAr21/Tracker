//
//  TrackersService.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import Foundation

protocol TrackersService {
    var categories: [TrackerCategory] { get }
    var categoriesList: [String] { get }
    var selectWeekdays: [String] { get }
    var selectCategory: String? { get }

    func updateCategoriesList(categoryTracker: TrackerCategory)
    func updateWeekdays(newSelectWeekdays: [String: Bool])
    func updateSelectCategory(newSelectCategory: String)
    func addCategory(newCategory: String)
    func removeSelectItems()
}

final class TrackersServiceImp: TrackersService {
    static let DidChangeTrackersNotification = Notification.Name(rawValue: "TrackersDidChange")
    static let DidChangeSelectItemsNotification = Notification.Name(rawValue: "SelectItemDidChange")
    static let DidChangeCategoriesNotification = Notification.Name(rawValue: "CategoriesDidChange")

    private(set) var categories: [TrackerCategory] = []
    private(set) var categoriesList: [String] = ["Baжное"]
    private(set) var selectWeekdays: [String] = []
    private(set) var selectCategory: String?

    func updateCategoriesList(categoryTracker: TrackerCategory) {
        guard let index = categories.firstIndex(where: { $0.title == categoryTracker.title }) else {
            categories.append(categoryTracker)
            NotificationCenter.default.post(name: TrackersServiceImp.DidChangeTrackersNotification, object: self)
            return
        }
        var newCategories: [TrackerCategory] = []
        let category = categories.remove(at: index)
        var trackerListCategory: [Tracker] = []
        trackerListCategory = category.trackersList
        let newTracker = categoryTracker.trackersList[0]
        trackerListCategory.append(newTracker)
        newCategories = categories
        newCategories.insert(TrackerCategory(title: categoryTracker.title, trackersList: trackerListCategory), at: index)
        categories = newCategories
        NotificationCenter.default.post(name: TrackersServiceImp.DidChangeTrackersNotification, object: self)
    }

    func updateWeekdays(newSelectWeekdays: [String: Bool]) {
        let shortWeekdays = Calendar.sortedShortWeekdays()
        let weekdays = Calendar.sortedWeekdays()
        var newWeekdays: [String] = []

        weekdays.enumerated().forEach { idx, day in
            if newSelectWeekdays[day] == true {
                newWeekdays.append(shortWeekdays[idx])
            }
        }
        selectWeekdays = newWeekdays
        NotificationCenter.default.post(name: TrackersServiceImp.DidChangeSelectItemsNotification, object: self)
    }

    func updateSelectCategory(newSelectCategory: String) {
        selectCategory = newSelectCategory
        NotificationCenter.default.post(name: TrackersServiceImp.DidChangeSelectItemsNotification, object: self)
    }

    func addCategory(newCategory: String) {
        categoriesList.append(newCategory)
        NotificationCenter.default.post(name: TrackersServiceImp.DidChangeCategoriesNotification, object: self)
    }

    func removeSelectItems() {
        selectCategory = nil
        selectWeekdays = []
    }
}
