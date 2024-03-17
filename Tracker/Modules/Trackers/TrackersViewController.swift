//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit
import YandexMobileMetrica

final class TrackersViewController<View: TrackersView>: BaseViewController<View> {
    var completedTrackers: [TrackerRecord] = []
    var categories: [TrackerCategory] = []
    var openCreateTracker: (() -> Void)?
    var openEditHabitClosure: ((TrackerModel) -> Void)?
    var openFiltersClosure: (() -> Void)?

    private var trackersObserver: NSObjectProtocol?
    private var filter: Filters = .all

    private let dataProvider: DataProvider

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return datePicker
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter

    }()

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        convertCoreDataInModel()
        datePickerValueChanged()
        setupBar()
        fetchTrackerRecord()

        rootView.delegate = self
        rootView.setView()

        trackersObserver = NotificationCenter.default.addObserver(
            forName: DataProvider.DidChangeCategoriesNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else {
                return
            }

            updateTrackers()
        }

        YMMYandexMetrica.reportEvent("open", parameters: ["screen": "Main"])
    }

    override func viewDidLayoutSubviews() {
        rootView.updateCollection()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        YMMYandexMetrica.reportEvent("close", parameters: ["screen": "Main"])
    }

    // MARK: - Private methods

    private func updateTrackers() {
        filter = dataProvider.selectFilter
        convertCoreDataInModel()
        if !categories.isEmpty {
            switch filter {
            case .all:
                convertCoreDataInModel()
            case .today:
                datePicker.date = Date()
                dataProvider.updateFilter(filter: .all)
            case .complete:
                updateVisibleTracker(isComplete: true)
            case .uncomplete:
                updateVisibleTracker(isComplete: false)
            }
            reloadVisibleCategories(text: nil, isFilter: true)
        } else {
            reloadVisibleCategories(text: nil, isFilter: false)
        }
    }

    private func setupBar() {
        let rectInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let addButtonImage = UIImage(named: "AddTracker")?.withAlignmentRectInsets(rectInsets).withTintColor(.trackerFontBlack)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(createNewTracker))

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

        title = RootTab.tracker.tabBarItem.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }

    private func isSameTracker(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }

    private func isNotSameTracker(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id != id && isSameDay
    }

    private func convertCoreDataInModel() {
        var categoryList: [Tracker] = []
        categories = dataProvider.trackerCategories.compactMap { category -> TrackerCategory? in
            guard let title = category.title, let trackers = category.trackers else {
                return nil
            }

            let newTrackers: [Tracker] = trackers.compactMap { tracker -> Tracker? in
                guard let trackerCoreData = tracker as? TrackerCoreData,
                      let id = trackerCoreData.id,
                      let name = trackerCoreData.name,
                      let color = trackerCoreData.color as? UIColor,
                      let emoji = trackerCoreData.emoji,
                      let schedule = trackerCoreData.schedule as? [Weekday]
                else {
                    return nil
                }

                if trackerCoreData.isFixed {
                    categoryList.append(Tracker(
                        id: id,
                        name: name,
                        color: color,
                        emoji: emoji,
                        schedule: schedule,
                        isFixed: trackerCoreData.isFixed
                    ))
                    return nil
                }

                return Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: schedule,
                    isFixed: trackerCoreData.isFixed
                )

            }
            return newTrackers.isEmpty ? nil : TrackerCategory(title: title, trackersList: newTrackers)
        }

        if !categoryList.isEmpty {
            categories.insert(TrackerCategory(title: NSLocalizedString("tracker.category", comment: "Text displayed on tracker"), trackersList: categoryList), at: 0)
        }
    }

    private func fetchTrackerRecord() {
        completedTrackers = dataProvider.fetchedTrackerRecord().compactMap {
            guard let id = $0.id, let date = $0.date else {
                return nil
            }

            return TrackerRecord(id: id, date: date)
        }
    }

    private func updateVisibleTracker(isComplete: Bool) {
        let index = Calendar.current.component(.weekday, from: datePicker.date)
        var sortedCategories: [TrackerCategory] = []

        for category in categories {
            let sortedTrackerList = category.trackersList.filter {
                isComplete ? isTrackerCompleteToday(trackerId: $0.id) : isTrackerUncompleteToday(trackerId: $0.id)
            }

            if !sortedTrackerList.isEmpty {
                sortedCategories.append(TrackerCategory(title: category.title, trackersList: sortedTrackerList))
            }
        }

        categories = sortedCategories
    }

    @objc private func datePickerValueChanged() {
        updateTrackers()
    }

    @objc private func createNewTracker() {
        openCreateTracker?()
    }
}

// MARK: - TrackersViewDelegate

extension TrackersViewController: TrackersViewDelegate {
    func reloadVisibleCategories(text: String?, isFilter: Bool) {
        let index = Calendar.current.component(.weekday, from: datePicker.date)
        var sortedCategories: [TrackerCategory] = []

        for category in categories {
            let sortedTrackerList = category.trackersList.filter {
                text != nil ?
                $0.name.lowercased().contains(text ?? "") && $0.schedule.contains(Weekday.allCases[index - 1]) :
                $0.schedule.contains(Weekday.allCases[index - 1])
            }

            if !sortedTrackerList.isEmpty {
                sortedCategories.append(TrackerCategory(title: category.title, trackersList: sortedTrackerList))
            }
        }

        rootView.reloadData(
            newCategories: sortedCategories,
            placeholder: text != nil || isFilter ? .notFoundCategories : .emptyCategories
        )
    }

    func isTrackerCompleteToday(trackerId: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: trackerId)
        }
    }

    func isTrackerUncompleteToday(trackerId: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isNotSameTracker(trackerRecord: trackerRecord, id: trackerId)
        }
    }

    func enableDoneButton(completion: (Bool) -> ()) {
        completion(!(datePicker.date > Date()))
    }

    func filterDidTap() {
        openFiltersClosure?()
    }
}

// MARK: - TrackerCollectionCellDelegate

extension TrackersViewController: TrackerCollectionCellDelegate {
    func countCompletedTracker(trackerId: UUID) -> Int {
        fetchTrackerRecord()
        return completedTrackers.filter({ $0.id == trackerId }).count
    }

    func completeTracker(id: UUID) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        try? dataProvider.addRecordTracker(trackerRecord)
        completedTrackers.append(trackerRecord)
    }

    func uncompleteTracker(id: UUID) {
        guard
            let trackerRecord = completedTrackers.filter({ isSameTracker(trackerRecord: $0, id: id) }).first
        else {
            return
        }

        completedTrackers.removeAll { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
        dataProvider.deleteRecordTracker(trackerRecord)
        datePickerValueChanged()
    }

    func pinTracker(trackerId: UUID?) {
        guard let trackerId else {
            return
        }

        dataProvider.updateTracker(trackerId: trackerId)
        convertCoreDataInModel()
        datePickerValueChanged()
    }

    func editHabit(tracker: Tracker, category: String, countDay: Int) {
        let model = TrackerModel(
            id: tracker.id,
            name: tracker.name,
            category: category,
            weekdays: tracker.schedule,
            schedule: tracker.schedule.count == 7 ?
                NSLocalizedString("newHabit.everyDay", comment: "Text displayed on tracker") :
                tracker.schedule.map({$0.shortName}).joined(separator: ", "),
            color: Constants.color.firstIndex(where: {$0 == tracker.color}) ?? 0,
            emoji: Constants.emoji.firstIndex(where: {$0 == tracker.emoji}) ?? 0,
            countDay: countDay
        )
        openEditHabitClosure?(model)
    }

    func deleteTracker(trackerID: UUID) {
        let alert = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить трекер?",
            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive) { [weak self] _ in
                self?.dataProvider.deleteTracker(trackerID)
            }
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
