//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class StatisticViewController<View: StatisticView>: BaseViewController<View> {
    private let dataProvider: DataProvider

    private var completedTrackers: [TrackerRecord] = []
    private var trackersObserver: NSObjectProtocol?

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

        trackersObserver = NotificationCenter.default.addObserver(
            forName: DataProvider.DidChangeCategoriesNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else {
                return
            }

            completedTrackers = fetchTrackerRecord()
            rootView.reload()
        }
    }

    private func fetchTrackerRecord() -> [TrackerRecord] {
        dataProvider.fetchedTrackerRecord().compactMap {
            guard let id = $0.id, let date = $0.date else {
                return nil
            }

            return TrackerRecord(id: id, date: date)
        }
    }

    private func setupBar() {
        title = RootTab.statistic.tabBarItem.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }

    private func updateCompleteTrackers() {
        completedTrackers = dataProvider.fetchedTrackerRecord().compactMap {
            guard let id = $0.id, let date = $0.date else {
                return nil
            }

            return TrackerRecord(id: id, date: date)
        }
    }
}

extension StatisticViewController: StatisticViewDelegate {
    func setCountBestPeriod() -> String {
        updateCompleteTrackers()
        var idDict: [UUID: Int] = [:]
        Set(completedTrackers.map { $0.id }).forEach { id in
            idDict[id] = completedTrackers.filter { $0.id == id }.count
        }
        return String(describing: idDict.values.max() ?? 0)
    }

    func setCountDay() -> String {
        updateCompleteTrackers()
        var idDict: [Date: Int] = [:]
        Set(completedTrackers.map { $0.date }).forEach { date in
            idDict[date] = completedTrackers.filter { $0.date == date }.count
        }
        return String(describing: idDict.values.max() ?? 0)
    }

    func setCountCompletedTracker() -> String {
        updateCompleteTrackers()
        return String(describing: completedTrackers.count)
    }

    func setMedian() -> String {
        updateCompleteTrackers()
        let countDate = Set(completedTrackers.map { $0.date }).count
        return  String(describing: countDate != 0 ? (completedTrackers.count / countDate) : 0)
    }
}
