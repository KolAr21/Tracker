//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class NewHabitViewController<View: NewHabitView>: BaseViewController<View> {
    var onOpenSchedule: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()
        rootView.delegate = self

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
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

    func didTapCancelButton() {
        dismiss(animated: true)
    }
}
