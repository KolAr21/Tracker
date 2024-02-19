//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Арина Колганова on 19.02.2024.
//

import Foundation

final class CategoryViewModel {
    let category: String
    private let isSelect: Bool

    init(category: String, isSelect: Bool) {
        self.category = category
        self.isSelect = isSelect
    }

    var categoryLabelBinding: Binding<String>? {
        didSet {
            categoryLabelBinding?(category)
        }
    }

    var categorySelectBinding: Binding<Bool>? {
        didSet {
            categorySelectBinding?(isSelect)
        }
    }
}
