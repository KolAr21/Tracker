//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class StatisticViewController<View: StatisticView>: BaseViewController<View> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()
    }
}
