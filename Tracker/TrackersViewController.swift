//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersViewController<View: TrackersView>: BaseViewController<View> {
    var completedTrackers: [TrackerRecord] = []
    var categories: [TrackerCategory]
    var openCreateTracker: (() -> Void)?

    private var trackersObserver: NSObjectProtocol?
    private var currentDate: Date = Date()

    private lazy var datePicker = UIDatePicker()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter

    }()

    let trackerService: TrackersService

    init(trackerService: TrackersService) {
        self.trackerService = trackerService
        self.categories = trackerService.categories

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        datePickerValueChanged()
        setupBar()

        rootView.delegate = self
        rootView.trackerService = trackerService
        rootView.setView()

        trackersObserver = NotificationCenter.default.addObserver(
            forName: TrackersServiceImp.DidChangeTrackersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            categories = trackerService.categories
            datePickerValueChanged()
        }
    }

    // MARK: - Private methods

    private func setupBar() {
        let rectInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let addButtonImage = UIImage(named: "AddTracker")?.withAlignmentRectInsets(rectInsets)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(createNewTracker))

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

        title = RootTab.tracker.tabBarItem.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }

    @objc private func datePickerValueChanged() {
        currentDate = datePicker.date
        reloadVisibleCategories(text: nil)
    }

    @objc private func createNewTracker() {
        openCreateTracker?()
    }

    private func isSameTracker(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
}

// MARK: - TrackersViewDelegate

extension TrackersViewController: TrackersViewDelegate {
    func reloadVisibleCategories(text: String?) {
        let selectedDate = currentDate
        let formattedDate = dateFormatter.string(from: selectedDate)
        var sortedCategories: [TrackerCategory] = []
        for category in categories {
            let sortedTrackerList = category.trackersList.filter {
                text != nil ? $0.name.lowercased().contains(text ?? "") && $0.schedule.contains(formattedDate) : $0.schedule.contains(formattedDate)
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
        completion(!(currentDate > Date()))
    }
}

// MARK: - TrackerCollectionCellDelegate

extension TrackersViewController: TrackerCollectionCellDelegate {
    func countCompletedTracker(trackerId: UUID) -> Int {
        completedTrackers.filter { $0.id == trackerId}.count
    }

    func completeTracker(id: UUID) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
    }

    func uncompleteTracker(id: UUID) {
        completedTrackers.removeAll { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
    }
}
