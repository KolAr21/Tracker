//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import UIKit

final class FiltersViewController<View: FiltersView>: BaseViewController<View> {
    var addNewCategoryClosure: (() -> ())?
    let dataProvider: DataProvider

    private var categoriesObserver: NSObjectProtocol?

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
        rootView.selectFilter = dataProvider.selectFilter.rawValue
        rootView.setView()

        setupBar()
    }

    // MARK: - Private methods

    private func setupBar() {
        title = NSLocalizedString("main.filters", comment: "Text displayed on tracker")
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
}

// MARK: - CategoryViewDelegate

extension FiltersViewController: FiltersViewDelegate {
    func updateSelectFilter(newSelectFilter: Filters) {
        dataProvider.updateFilter(filter: newSelectFilter)
    }

    func dismissVC() {
        dismiss(animated: true)
    }
}
