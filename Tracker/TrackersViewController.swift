//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersViewController<View: TrackersView>: BaseViewController<View> {
    var openCreateTracker: (() -> Void)?
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBar()
        rootView.setView()
    }

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
            .foregroundColor: UIColor(named: "black") ?? .black,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }

    @objc private func createNewTracker() {
        openCreateTracker?()
    }
}
