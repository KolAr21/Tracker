//
//  ScheduleView.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

protocol ScheduleView: UIView {
    var delegate: ScheduleViewDelegate? { get set }

    func setView()
}

protocol ScheduleViewDelegate: AnyObject {
    func updateWeekdays(newSelectWeekdays: [Weekday])
    func dismissVC()
}

final class ScheduleViewImp: UIView, ScheduleView {
    var delegate: ScheduleViewDelegate?

    private var weekdaySwitch: [Weekday] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trackerGray
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerWhite, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(tableView)
        addSubview(doneButton)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -134),

            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Private methods

    @objc private func didTapDoneButton() {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ScheduleTableViewCell else {
                return
            }
            if cell.switcher.isOn {
                weekdaySwitch.append(row == 6 ? Weekday.Sunday : Weekday.allCases[row + 1])
            }
        }
        delegate?.updateWeekdays(newSelectWeekdays: weekdaySwitch)
        delegate?.dismissVC()
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ScheduleCell",
            for: indexPath
        ) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(weekday: indexPath.row == 6 ? Weekday.Sunday : Weekday.allCases[indexPath.row + 1])

        switch indexPath.row {
        case 0:
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case 6:
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default: break
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
