//
//  RootTab.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

enum RootTab: Int {
    case tracker
    case statistic

    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(
            title: title,
            image: image,
            tag: self.rawValue
        )
        return tabBarItem
    }

    private var title: String? {
        switch self {
        case .tracker:
            return NSLocalizedString("navigation.trackers", comment: "Text displayed on tracker")
        case .statistic:
            return NSLocalizedString("navigation.statistic", comment: "Text displayed on tracker")
        }
    }

    private var image: UIImage? {
        switch self {
        case .tracker:
            return UIImage(named: "Tracker")
        case .statistic:
            return UIImage(named: "Statistic")
        }
    }
}
