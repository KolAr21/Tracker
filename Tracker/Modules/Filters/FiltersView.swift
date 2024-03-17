//
//  FiltersView.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import UIKit

protocol FiltersView: UIView {
    var delegate: FiltersViewDelegate? { get set }
    var selectFilter: String? { get set }

    func setView()
    func reload()
}

protocol FiltersViewDelegate: AnyObject {
    func updateSelectFilter(newSelectFilter: Filters)
    func dismissVC()
}

final class FiltersViewImp: UIView, FiltersView {
    var delegate: FiltersViewDelegate?
    var selectFilter: String?
    var filters: [Filters] = Filters.allCases

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        tableView.separatorColor = .trackerGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterCell",
            for: indexPath
        ) as? FiltersTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        cell.configure(filter: filters[indexPath.row].rawValue, isSelect: filters[indexPath.row].rawValue != selectFilter)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewImp: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.updateSelectFilter(newSelectFilter: filters[indexPath.row])
        delegate?.dismissVC()
    }
}
