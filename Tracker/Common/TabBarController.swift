//
//  TabBarController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .trackerWhite
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.trackerGray.cgColor
        tabBar.clipsToBounds = true
    }
}
