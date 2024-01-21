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
    var selectSchedule: String? { get set }
    var selectCategory: String? { get set }

    func setView()
    func reloadData()
}

protocol NewHabitViewDelegate: AnyObject {
    func didTapScheduleButton()
    func didTapCategoryButton()
    func didTapCancelButton()
}

final class NewHabitViewImp: UIView, NewHabitView {
    weak var delegate: NewHabitViewDelegate?
    var trackerService: TrackersService?
    var selectSchedule: String?
    var selectCategory: String?

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
        textField.clearButtonMode = .whileEditing
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .trackerRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    } ()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 8
        stackView.addArrangedSubview(nameHabitTextField)
        stackView.addArrangedSubview(textFieldLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        selectCategory = trackerService?.selectCategory
        backgroundColor = .trackerWhite

        addSubview(textFieldStackView)
        addSubview(tableView)
        addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textFieldStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            textFieldLabel.bottomAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: -8),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -34),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])

        nameHabitTextField.delegate = self

        tableView.dataSource = self
        tableView.delegate = self

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(recognizer)
    }

    func reloadData() {
        tableView.reloadData()
    }

    // MARK: - Private methods

    @objc private func viewDidTap() {
        nameHabitTextField.resignFirstResponder()
        guard let text = nameHabitTextField.text else {
            textFieldLabel.isHidden = true
            return
        }

        if text.count < 38 {
            textFieldLabel.isHidden = true
        }
    }

    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc private func didTapCreateHabitButton() {
        let category = "Радостные мелочи"
        guard let schedule = trackerService?.selectWeekdays else {
            return
        }
        let newTracker = Tracker(id: 0, name: "Кошка заслонила камеру на созвоне", color: .trackerRed, emoji: "😻", schedule: schedule)
        let trackerCategory = TrackerCategory(title: category, trackersList: [newTracker])
        trackerService?.updateCategoriesList(categoryTracker: trackerCategory)
        delegate?.didTapCancelButton()
    }
}

extension NewHabitViewImp: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }

        if text.count >= 38 {
            textFieldLabel.isHidden = false
            return false
        } else {
            textFieldLabel.isHidden = true
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }

        return text.count > 38 ? false : true
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
            cell.selectLabel.isHidden = selectSchedule == nil ? true : false
            cell.selectLabel.text = selectSchedule ?? ""
        } else {
            cell.selectLabel.isHidden = selectCategory == nil ? true : false
            cell.selectLabel.text = selectCategory ?? ""
        }
        cell.nameLabel.text = indexPath.row == 1 ? "Расписание" : "Категория"
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
