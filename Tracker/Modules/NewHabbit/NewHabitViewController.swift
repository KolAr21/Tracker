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

    private var parameters: [String]
    private var model: TrackerModel?
    private var dataProvider: DataProvider
    private var itemsObserver: NSObjectProtocol?

    init(parameters: [String], model: TrackerModel?, dataProvider: DataProvider) {
        self.parameters = parameters
        self.model = model
        self.dataProvider = dataProvider

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.parameters = parameters
        rootView.delegate = self
        rootView.setView()
        rootView.setSettings(model: model)

        setupBar()

        itemsObserver = NotificationCenter.default.addObserver(
            forName: DataProvider.DidChangeSelectItemsNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else {
                return
            }

            self.rootView.selectCategory = dataProvider.selectCategory
            self.rootView.selectSchedule = dataProvider.selectWeekdays.count == 7 ?
                NSLocalizedString("newHabit.everyDay", comment: "Text displayed on tracker") :
                dataProvider.selectWeekdays.map({$0.shortName}).joined(separator: ", ")
            self.rootView.selectWeekdays = dataProvider.selectWeekdays
            self.rootView.isEnableButton()
            self.rootView.reloadData()
        }
    }

    // MARK: - Private methods

    private func setupBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        guard model != nil else {
            title = parameters.count == 2 ?
                NSLocalizedString("newHabit.titleFirst", comment: "Text displayed on tracker") :
                NSLocalizedString("newHabit.titleSecond", comment: "Text displayed on tracker")
            return
        }

        title = NSLocalizedString("newHabit.titleThird", comment: "Text displayed on tracker")
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
        dataProvider.removeSelectItems()
        dismiss(animated: true)
    }

    func didTapCreateButton(category: TrackerCategory) {
        try? dataProvider.addCategory(category)
    }

    func didTapSaveButton(tracker: Tracker, category: String) {
        dataProvider.saveTracker(tracker: tracker, category: category)
    }

    func updateSelectItem(category: String, weekdays: [Weekday]) {
        dataProvider.updateSelectCategory(newSelectCategory: category)
        dataProvider.updateWeekdays(newSelectWeekdays: weekdays)
    }
}
