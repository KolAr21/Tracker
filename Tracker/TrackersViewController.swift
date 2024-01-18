//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersViewController<View: TrackersView>: BaseViewController<View> {
    var categories: [TrackerCategory] = [] //Оно здесь только ради чеклиста
    var openCreateTracker: (() -> Void)?

    private var categoriesObserver: NSObjectProtocol?

    let trackerService: TrackersService

    init(trackerService: TrackersService) {
        self.trackerService = trackerService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBar()

        rootView.trackerService = trackerService
        rootView.setView()

        categoriesObserver = NotificationCenter.default.addObserver(
            forName: TrackersServiceImp.DidChangeCategoriesNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.rootView.reloadData()
            }
    }

    // MARK: - Private methods

    private func setupBar() {
        let rectInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let addButtonImage = UIImage(named: "AddTracker")?.withAlignmentRectInsets(rectInsets)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(createNewTracker))

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

        title = RootTab.tracker.tabBarItem.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        let search = UISearchController(searchResultsController: nil)
        navigationItem.searchController = search

    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
    }

    @objc private func createNewTracker() {
        openCreateTracker?()
    }
}
