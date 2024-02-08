//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

final class CategoryViewController<View: CategoryView>: BaseViewController<View> {
    var addNewCategoryClosure: (() -> ())?
    let trackerService: TrackersService

    private var categoriesObserver: NSObjectProtocol?

    init(trackerService: TrackersService) {
        self.trackerService = trackerService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
        rootView.trackerService = trackerService
        rootView.setView()

        setupBar()

        categoriesObserver = NotificationCenter.default.addObserver(
            forName: TrackersServiceImp.DidChangeCategoriesNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.rootView.reload()
        }
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

// MARK: - CategoryViewDelegate

extension CategoryViewController: CategoryViewDelegate {
    func addNewCategory() {
        addNewCategoryClosure?()
    }

    func dismissVC() {
        dismiss(animated: true)
    }
}
