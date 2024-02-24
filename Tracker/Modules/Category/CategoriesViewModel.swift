//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Арина Колганова on 19.02.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoriesViewModel {
    private let dataProvider: DataProvider

    private var categoriesObserver: NSObjectProtocol?

    private(set) var categories: [CategoryViewModel] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }

    var categoriesBinding: Binding<[CategoryViewModel]>?

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        categories = getCategoriesFromStore()

        categoriesObserver = NotificationCenter.default.addObserver(
            forName: DataProvider.DidChangeCategoriesNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else {
                return
            }

            self.categories = self.getCategoriesFromStore()
        }
    }

    func updateSelectCategory(newSelectCategory: String) {
        dataProvider.updateSelectCategory(newSelectCategory: newSelectCategory)
    }

    private func getCategoriesFromStore() -> [CategoryViewModel] {
        dataProvider.trackerCategories.compactMap {
            CategoryViewModel(
                category: $0.title ?? "",
                isSelect: dataProvider.selectCategory == $0.title ? true : false
            )
        }
    }
}
