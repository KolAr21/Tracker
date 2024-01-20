//
//  TrackersService.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import Foundation

protocol TrackersService {
    var categories: [TrackerCategory] { get set }
    var completedTrackers: [TrackerRecord] { get set }
    var weekdaysDictionary: [String: Bool] { get set }

    func appendCompletedTracker(newTracker: TrackerRecord)
    func removeCompletedTracker(cell indexPath: UInt)
    func updateCategoriesList(categoryTracker: TrackerCategory)
    func updateWeekdays(newWeekdayDictionary: [String: Bool])
}

final class TrackersServiceImp: TrackersService {
    static let DidChangeCategoriesNotification = Notification.Name(rawValue: "CategoriesDidChange")

    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var weekdaysDictionary: [String: Bool] = [:]

    func appendCompletedTracker(newTracker: TrackerRecord) {
        completedTrackers.append(newTracker)
    }

    func removeCompletedTracker(cell indexPath: UInt) {
        guard let id = completedTrackers.firstIndex(where: { $0.id == indexPath }) else {
            return
        }
        completedTrackers.remove(at: id)
    }

    func updateCategoriesList(categoryTracker: TrackerCategory) {
        var newCategories: [TrackerCategory] = []
        guard let index = categories.firstIndex(where: { $0.title == categoryTracker.title }) else {
            newCategories = categories
            newCategories.append(categoryTracker)
            categories = newCategories
            NotificationCenter.default.post(name: TrackersServiceImp.DidChangeCategoriesNotification, object: self)
            return
        }
        let category = categories.remove(at: index)
        var trackerListCategory: [Tracker] = []
        trackerListCategory = category.trackersList
        let newTracker = categoryTracker.trackersList[0]
        trackerListCategory.append(newTracker)
        newCategories = categories
        newCategories.append(TrackerCategory(title: categoryTracker.title, trackersList: trackerListCategory))
        categories = newCategories
        NotificationCenter.default.post(name: TrackersServiceImp.DidChangeCategoriesNotification, object: self)
    }

    func updateWeekdays(newWeekdayDictionary: [String: Bool]) {
        weekdaysDictionary = newWeekdayDictionary
    }
}
