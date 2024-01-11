//
//  SplashView.swift
//  Tracker
//
//  Created by Арина Колганова on 11.01.2024.
//

import UIKit

protocol SplashView: UIView {
    func setView()
}

final class SplashViewImp: UIView, SplashView {
    func setView() {
        backgroundColor = .red
    }
}
