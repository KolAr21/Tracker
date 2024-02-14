//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersViewController<View: TrackersView>: BaseViewController<View> {
    var completedTrackers: [TrackerRecord] = []
    var categories: [TrackerCategory] = []
    var openCreateTracker: (() -> Void)?

    private var trackersObserver: NSObjectProtocol?

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
            guard let self = self else {
                return
            }

            convertCoreDataInModel()
            datePickerValueChanged()
        }
    }

    // MARK: - Private methods

    private func setupBar() {
        let rectInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let addButtonImage = UIImage(named: "AddTracker")?.withAlignmentRectInsets(rectInsets)
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

    private func convertCoreDataInModel() {
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

                return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
            }
            return TrackerCategory(title: title, trackersList: newTrackers)
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

    @objc private func datePickerValueChanged() {
        reloadVisibleCategories(text: nil)
    }

    @objc private func createNewTracker() {
        openCreateTracker?()
    }
}

// MARK: - TrackersViewDelegate

extension TrackersViewController: TrackersViewDelegate {
    func reloadVisibleCategories(text: String?) {
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
            placeholder: text != nil ? .notFoundCategories : .emptyCategories
        )
    }

    func isTrackerCompleteToday(trackerId: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: trackerId)
        }
    }

    func enableDoneButton(completion: (Bool) -> ()) {
        completion(!(datePicker.date > Date()))
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
    }
}
