//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class NewHabitViewController<View: NewHabitView>: BaseViewController<View> {
    var onOpenSchedule: (() -> Void)?
    var onOpenCategory: (() -> Void)?
    var trackerService: TrackersService

    init(trackerService: TrackersService) {
        self.trackerService = trackerService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()
        rootView.delegate = self
        rootView.trackerService = trackerService

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
        navigationItem.hidesBackButton = true
        title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}

// MARK: - NewHabitViewDelegate

extension NewHabitViewController: NewHabitViewDelegate {
    func didTapScheduleButton() {
        onOpenSchedule?()
    }

    func didTapCategoryButton() {
        onOpenCategory?()
    }

    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
