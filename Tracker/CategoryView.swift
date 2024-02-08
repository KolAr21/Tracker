//
//  CategoryView.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

protocol CategoryView: UIView {
    var trackerService: TrackersService? { get set }
    var delegate: CategoryViewDelegate? { get set }

    func setView()
    func reload()
}

protocol CategoryViewDelegate: AnyObject {
    func addNewCategory()
    func dismissVC()
}

final class CategoryViewImp: UIView, CategoryView {
    var trackerService: TrackersService?
    var delegate: CategoryViewDelegate?

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
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        tableView.separatorColor = .trackerGray
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
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(tableView)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        guard let trackerService else {
            return
        }

        if trackerService.categoriesList.isEmpty {
            addSubview(placeholderStackView)

            NSLayoutConstraint.activate([
                placeholderStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                placeholderStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                placeholderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                placeholderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
        }
    }

    func reload() {
        tableView.reloadData()
        didHiddenPlaceholder()
    }

    @objc private func addNewCategory() {
        delegate?.addNewCategory()
    }

    private func didHiddenPlaceholder() {
        guard let trackerService else {
            return
        }

        placeholderStackView.isHidden = !trackerService.categoriesList.isEmpty
    }
}

extension CategoryViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerService?.categoriesList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryCell",
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        guard let trackerService else {
            return cell
        }

        if trackerService.categoriesList.count == 1 {
            cell.layer.cornerRadius = 16
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if indexPath.row == trackerService.categoriesList.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        cell.label.text = trackerService.categoriesList[indexPath.row]
        if cell.label.text == trackerService.selectCategory {
            cell.arrowImage.isHidden = false
        } else {
            cell.arrowImage.isHidden = true
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let trackerService else {
            return
        }
        trackerService.updateSelectCategory(newSelectCategory: trackerService.categoriesList[indexPath.row])
        delegate?.dismissVC()
    }
}
