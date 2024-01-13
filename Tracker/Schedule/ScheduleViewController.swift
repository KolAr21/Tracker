//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

final class ScheduleViewController<View: ScheduleView>: BaseViewController<View> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()
    }
}
