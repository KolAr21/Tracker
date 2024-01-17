//
//  CategoryView.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

protocol CategoryView: UIView {
    var trackerService: TrackersService? { get set }
    func setView()
}

final class CategoryViewImp: UIView, CategoryView {
    var trackerService: TrackersService?

    private lazy var placeholderImageView: UIImageView = {
        UIImageView(image: UIImage(named: "PlaceholderTracker"))
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n объединить по смыслу"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private lazy var placeholderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8
        stackView.addArrangedSubview(placeholderImageView)
        stackView.addArrangedSubview(placeholderLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trackerGray
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerBlack
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerWhite, for: .normal)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(tableView)
        addSubview(addButton)

        if (trackerService?.categories.isEmpty) != nil {
            addSubview(placeholderStackView)

            NSLayoutConstraint.activate([
                placeholderStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                placeholderStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                placeholderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                placeholderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
        }

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
