//
//  BaseViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

protocol CoreViewController: AnyObject {
    associatedtype View

    var rootView: View { get }
}

class BaseViewController<View: UIView>: UIViewController, CoreViewController {
    var rootView: View = View()

    override func loadView() {
        view = rootView
    }
}
