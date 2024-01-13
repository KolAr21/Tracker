//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class CreateTrackerViewController<View: CreateTrackerView>: BaseViewController<View> {
    var openNewHabbit: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        rootView.setView()
    }
}

// MARK: - CreateTrackerViewDelegate

extension CreateTrackerViewController: CreateTrackerViewDelegate {
    func openNewHabit() {
        openNewHabbit?()
    }
}
