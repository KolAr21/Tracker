//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 15.01.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    var addNewCategoryClosure: (() -> ())?

    private var viewModel: CategoriesViewModel

    private lazy var placeholderImageView: UIImageView = {
        UIImageView(image: UIImage(named: "PlaceholderTracker"))
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("category.empty", comment: "Text displayed on tracker")
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
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        tableView.separatorColor = .trackerGray
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerFontBlack
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerWhite, for: .normal)
        button.setTitle(NSLocalizedString("category.button", comment: "Text displayed on tracker"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        return button
    }()

    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setupBar()
    }

    // MARK: - Private methods

    private func setView() {
        view.backgroundColor = .trackerWhite

        [tableView, placeholderStackView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),

            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        didHiddenPlaceholder(isHidden: !viewModel.categories.isEmpty)
    }

    private func bind() {
        viewModel.categoriesBinding = { [weak self] _ in
            self?.reload()
        }
    }

    private func setupBar() {
        title = NSLocalizedString("category.title", comment: "Text displayed on tracker")
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.trackerBlack,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }

    private func reload() {
        tableView.reloadData()
        didHiddenPlaceholder(isHidden: !viewModel.categories.isEmpty)
    }

    private func didHiddenPlaceholder(isHidden: Bool) {
        placeholderStackView.isHidden = isHidden
    }

    @objc private func addNewCategory() {
        addNewCategoryClosure?()
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryCell",
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        if viewModel.categories.count == 1 {
            cell.layer.cornerRadius = 16
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        cell.viewModel = viewModel.categories[indexPath.row]

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.updateSelectCategory(newSelectCategory: viewModel.categories[indexPath.row].category)
        dismiss(animated: true)
    }
}
