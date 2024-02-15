//
//  NewHabitView.swift
//  Tracker
//
//  Created by Арина Колганова on 13.01.2024.
//

import UIKit

protocol NewHabitView: UIView {
    var selectSchedule: String? { get set }
    var selectCategory: String? { get set }
    var parameters: [String] { get set }
    var selectWeekdays: [Weekday] { get set }
    var delegate: NewHabitViewDelegate? { get set }

    func setView()
    func reloadData()
    func isEnableButton()
}

protocol NewHabitViewDelegate: AnyObject {
    func didTapScheduleButton()
    func didTapCategoryButton()
    func didTapCancelButton()
    func didTapCreateButton(category: TrackerCategory)
}

final class NewHabitViewImp: UIView, NewHabitView {
    var selectSchedule: String?
    var selectCategory: String?
    var parameters: [String] = []
    var selectWeekdays: [Weekday] = []

    weak var delegate: NewHabitViewDelegate?

    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.register(
            TrackerCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HabitHeader"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        button.isUserInteractionEnabled = false
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
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 236))
        scrollView.contentSize = CGSize(width: screenWidth, height: 770)
        scrollView.backgroundColor = .trackerWhite
        addSubview(scrollView)

        scrollView.addSubview(textFieldStackView)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textFieldStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            textFieldStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            textFieldStackView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameHabitTextField.heightAnchor.constraint(equalToConstant: 75),
            textFieldLabel.bottomAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: -8),

            tableView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: parameters.count == 2 ? 150 : 75),
            tableView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -34),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),

            collectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16)
        ])

        nameHabitTextField.delegate = self

        tableView.dataSource = self
        tableView.delegate = self

        collectionView.dataSource = self
        collectionView.delegate = self

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func isEnableButton() {
        guard let text = nameHabitTextField.text,
              !text.isEmpty,
              selectCategory != nil,
              let count = collectionView.indexPathsForSelectedItems?.count,
              count == 2
        else {
            createButton.isUserInteractionEnabled = false
            createButton.backgroundColor = .trackerGray
            return
        }

        if parameters.count == 2 {
            guard !selectWeekdays.isEmpty else {
                createButton.isUserInteractionEnabled = false
                createButton.backgroundColor = .trackerGray
                return
            }
        }

        createButton.isUserInteractionEnabled = true
        createButton.backgroundColor = .trackerBlack
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
        guard let text = nameHabitTextField.text,
              let category = selectCategory,
              let emojiIndex = collectionView.indexPathsForSelectedItems?.filter({ $0.section == 0 }).first?.row,
              let colorIndex = collectionView.indexPathsForSelectedItems?.filter({ $0.section == 1 }).first?.row
        else {
            return
        }

        var newTracker = Tracker(
            id: UUID(),
            name: text,
            color: Constants.color[colorIndex],
            emoji: Constants.emoji[emojiIndex],
            schedule: Weekday.allCases
        )

        if parameters.count == 2 {
            newTracker = Tracker(id: UUID(), name: text, color: Constants.color[colorIndex], emoji: Constants.emoji[emojiIndex], schedule: selectWeekdays)
        }
        let trackerCategory = TrackerCategory(title: category, trackersList: [newTracker])
        delegate?.didTapCreateButton(category: trackerCategory)
        delegate?.didTapCancelButton()
    }
}

// MARK: - UITextFieldDelegate

extension NewHabitViewImp: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isEnableButton()
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
        nameHabitTextField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else {
            return false
        }

        return text.count > 38 ? false : true
    }
}

// MARK: - UITableViewDataSource

extension NewHabitViewImp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        parameters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewHabitCell",
            for: indexPath
        ) as? NewHabitTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 {
            cell.selectLabel.isHidden = selectCategory == nil ? true : false
            cell.selectLabel.text = selectCategory ?? ""
        } else {
            cell.selectLabel.isHidden = selectSchedule == nil ? true : false
            cell.selectLabel.text = selectSchedule ?? ""
        }
        if indexPath.row == parameters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 400, bottom: 0, right: 0)
        }
        cell.configure(parameter: indexPath.row == 1 ? "Расписание" : "Категория")
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

// MARK: - UICollectionViewDataSource

extension NewHabitViewImp: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "EmojiCell",
                for: indexPath
            ) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(emoji: Constants.emoji[indexPath.row])
            cell.layer.cornerRadius = 16
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ColorCell",
                for: indexPath
            ) as? ColorCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(color: Constants.color[indexPath.row])
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.color.count
        default:
            return Constants.emoji.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HabitHeader",
            for: indexPath
        ) as? TrackerCollectionHeaderView else {
            return UICollectionReusableView()
        }

        headerView.configure(text: Constants.headerName[indexPath.section])
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension NewHabitViewImp: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isEnableButton()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 16.0, bottom: 20.0, right: 16.0)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        isEnableButton()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitViewImp: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 44, height: 18)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 82
        return CGSize(width: width/6, height: width/6)
    }
}
