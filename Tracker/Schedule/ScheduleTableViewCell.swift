//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 14.01.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .trackerBlue
        return switcher
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(switcher)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "ScheduleCell")
        backgroundColor = .trackerBackground

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
