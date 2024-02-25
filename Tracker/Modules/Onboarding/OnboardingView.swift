//
//  OnboardingView.swift
//  Tracker
//
//  Created by Арина Колганова on 18.02.2024.
//

import UIKit

protocol OnboardingView: AnyObject {
    var parameter: Page? { get set }
    var delegate: OnboardingViewDelegate? { get set }

    func setView()
}

protocol OnboardingViewDelegate: AnyObject {
    func openTracker()
}

final class OnboardingViewImp: UIView, OnboardingView {
    var parameter: Page?
    var delegate: OnboardingViewDelegate?

    private lazy var backgroundImageView = UIImageView(image: parameter?.image)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = parameter?.title
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var trackerButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("onboarding.button", comment: "Text displayed on onboarding"), for: .normal)
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.addTarget(self, action: #selector(openTracker), for: .touchUpInside)
        return button
    }()

    func setView() {
        [backgroundImageView, titleLabel, trackerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 432),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            trackerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trackerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -84),
            trackerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func openTracker() {
        delegate?.openTracker()
    }
}
