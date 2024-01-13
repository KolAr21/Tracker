//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

final class NewHabitViewController<View: NewHabitView>: BaseViewController<View> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setView()
    }
}
