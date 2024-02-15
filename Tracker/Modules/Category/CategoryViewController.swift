//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

final class CategoryViewController<View: CategoryView>: BaseViewController<View> {
    var addNewCategoryClosure: (() -> ())?

    let dataProvider: DataProvider

    private var categories: [String] = []
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

        convertCoreDataInModel()

        rootView.selectCategory = dataProvider.selectCategory
        rootView.categories = categories
        rootView.delegate = self
        rootView.setView()

        setupBar()

        categoriesObserver = NotificationCenter.default.addObserver(
            forName: DataProvider.DidChangeCategoriesNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else {
                return
            }

            convertCoreDataInModel()
            rootView.categories = categories
            self.rootView.reload()
        }
    }

    // MARK: - Private methods

    private func convertCoreDataInModel() {
        categories = dataProvider.trackerCategories.compactMap {
            guard let title = $0.title/*, !categories.contains(title)*/ else {
                return nil
            }

            return title
        }
    }

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
    func updateSelectCategory(newSelectCategory: String) {
        dataProvider.updateSelectCategory(newSelectCategory: newSelectCategory)
    }

    func addNewCategory() {
        addNewCategoryClosure?()
    }

    func dismissVC() {
        dismiss(animated: true)
    }
}
