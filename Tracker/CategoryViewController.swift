//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

final class CategoryViewController<View: CategoryView>: BaseViewController<View> {
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

        rootView.trackerService = trackerService
        rootView.setView()

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
        title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}
