//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

final class ScheduleViewController<View: ScheduleView>: BaseViewController<View> {
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
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

// MARK: - ScheduleViewDelegate

extension ScheduleViewController: ScheduleViewDelegate {
    func updateWeekdays(newSelectWeekdays: [Weekday]) {
        dataProvider.updateWeekdays(newSelectWeekdays: newSelectWeekdays)
    }

    func dismissVC() {
        dismiss(animated: true)
    }
}
