//
//  CreateTrackerView.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol CreateTrackerView: UIView {
    var delegate: CreateTrackerViewDelegate? { get set }

    func setView()
}

protocol CreateTrackerViewDelegate: AnyObject {
    func openNewHabit()
    func openIrregularEvent()
}

final class CreateTrackerViewImp: UIView, CreateTrackerView {
    weak var delegate: CreateTrackerViewDelegate?

    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("createTracker.habit", comment: "Text displayed on tracker"), for: .normal)
        setSettingsButton(button: button)
        button.addTarget(self, action: #selector(openNewHabit), for: .touchUpInside)
        return button
    }()

    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("createTracker.event", comment: "Text displayed on tracker"), for: .normal)
        setSettingsButton(button: button)
        button.addTarget(self, action: #selector(openIrregularEvent), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 16
        stackView.addArrangedSubview(habitButton)
        stackView.addArrangedSubview(eventButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            eventButton.heightAnchor.constraint(equalToConstant: 60),

            buttonsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    // MARK: - Private methods

    private func setSettingsButton(button: UIButton) {
        button.backgroundColor = .trackerFontBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func openNewHabit(sender: UIButton!) {
        delegate?.openNewHabit()
    }

    @objc private func openIrregularEvent(sender: UIButton!) {
        delegate?.openIrregularEvent()
    }
}
