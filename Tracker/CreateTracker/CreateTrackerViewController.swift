//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class CreateTrackerViewController<View: CreateTrackerView>: BaseViewController<View> {
    var openNewHabitClosure: (() -> Void)?
    var openIrregularEventClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        rootView.setView()

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
        title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}

// MARK: - CreateTrackerViewDelegate

extension CreateTrackerViewController: CreateTrackerViewDelegate {
    func openNewHabit() {
        openNewHabitClosure?()
    }

    func openIrregularEvent() {
        openIrregularEventClosure?()
    }
}
