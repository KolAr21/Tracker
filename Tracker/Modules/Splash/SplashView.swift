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
    lazy var logoImageView: UIImageView = {
        UIImageView(image: UIImage(named: "Logo"))
    }()

    func setView() {
        backgroundColor = .trackerBlue

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
