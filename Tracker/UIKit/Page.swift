//
//  Page.swift
//  Tracker
//
//  Created by Арина Колганова on 18.02.2024.
//

import UIKit

enum Page: Int {
    case first
    case second

    var title: String? {
        switch self {
        case .first:
            return NSLocalizedString("onboarding.firstPage", comment: "Text displayed on onboarding")
        case .second:
            return NSLocalizedString("onboarding.secondPage", comment: "Text displayed on onboarding")
        }
    }

    var image: UIImage? {
        switch self {
        case .first:
            return UIImage(named: "FirstPage")
        case .second:
            return UIImage(named: "SecondPage")
        }
    }
}
