//
//  NewHabitView.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitView: UIView {
    var trackerService: TrackersService? { get set }
    var delegate: NewHabitViewDelegate? { get set }

    func setView()
}

protocol NewHabitViewDelegate: AnyObject {
    func didTapScheduleButton()
    func didTapCategoryButton()
    func didTapCancelButton()
}

final class NewHabitViewImp: UIView, NewHabitView {
    weak var delegate: NewHabitViewDelegate?
    var trackerService: TrackersService?

    private lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.trackerGray,
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        )
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .trackerBackground
        textField.returnKeyType = .go
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewHabitTableViewCell.self, forCellReuseIdentifier: "NewHabitCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trackerGray
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.trackerRed.cgColor
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerRed, for: .normal)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerWhite, for: .normal)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapCreateHabitButton), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 8
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(nameHabitTextField)
        addSubview(tableView)
        addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            nameHabitTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameHabitTextField.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameHabitTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -34),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Private methods

    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc private func didTapCreateHabitButton() {
        let category = "Радостные мелочи"
        let newTracker = Tracker(id: 0, name: "Кошка заслонила камеру на созвоне", color: .trackerRed, emoji: "😻", schedule: "5 дней")
        let trackerCategory = TrackerCategory(title: category, trackersList: [newTracker])
        trackerService?.updateCategoriesList(categoryTracker: trackerCategory)
        delegate?.didTapCancelButton()
    }
}

// MARK: - UITableViewDataSource

extension NewHabitViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewHabitCell",
            for: indexPath
        ) as? NewHabitTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
            cell.label.text = "Категория"
        }
        cell.label.text = indexPath.row == 1 ? "Расписание" : "Категория"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewHabitViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row == 1 else {
            delegate?.didTapCategoryButton()
            return
        }
        delegate?.didTapScheduleButton()
    }
}
