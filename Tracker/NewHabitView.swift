//
//  NewHabitView.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitView: UIView {
    func setView()
}

final class NewHabitViewImp: UIView, NewHabitView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(titleLabel)
        addSubview(nameHabitTextField)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            nameHabitTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameHabitTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameHabitTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: nameHabitTextField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setSettingsButton(button: UIButton) {
        button.setImage(UIImage(named: "Arrow"), for: .normal)
        button.backgroundColor = .trackerBackground
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.trackerBlack, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
    }
}

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
        cell.label.text = indexPath.row == 1 ? "Категория" : "Расписание"
        return cell
    }
}

extension NewHabitViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
