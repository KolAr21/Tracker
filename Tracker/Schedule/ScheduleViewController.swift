//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

final class ScheduleViewController<View: ScheduleView>: BaseViewController<View> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
        title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}
