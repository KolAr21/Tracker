//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 07.02.2024.
//

import UIKit

final class NewCategoryViewController<View: NewCategoryView>: BaseViewController<View> {
    var addNewCategoryClosure: (() -> ())?

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
        title = NSLocalizedString("category.title", comment: "Text displayed on tracker")
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}

// MARK: - NewCategoryViewDelegate

extension NewCategoryViewController: NewCategoryViewDelegate {
    func addCategory(newCategory: String) {
        try? dataProvider.addCategory(TrackerCategory(title: newCategory, trackersList: []))
    }

    func dismissVC() {
        dismiss(animated: true)
    }
}
