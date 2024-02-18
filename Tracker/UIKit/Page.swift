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
            return "Отслеживайте только то, что хотите"
        case .second:
            return "Даже если это \n не литры воды и йога"
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
