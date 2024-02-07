//
//  TrackersView.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

protocol TrackersView: UIView {
    var trackerService: TrackersService? { get set }
    var delegate: TrackersViewDelegate? { get set }
    var visibleCategories: [TrackerCategory] { get set }

    func setView()
    func reloadData(newCategories: [TrackerCategory], placeholder: Placeholder)
}

protocol TrackersViewDelegate: AnyObject {
    func enableDoneButton(completion: (Bool) -> ())
    func reloadVisibleCategories(text: String?)
    func isTrackerCompleteToday(trackerId: UInt) -> Bool
    func countCompletedTracker(trackerId: UInt) -> Int
}

final class TrackersViewImp: UIView, TrackersView {
    var trackerService: TrackersService?
    var delegate: TrackersViewDelegate?
    var visibleCategories: [TrackerCategory] = []

    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 5
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var searchTextField: UISearchTextField = {
        let search = UISearchTextField()
        search.clearButtonMode = .never
        search.backgroundColor = .trackerSearchBack
        search.textColor = .trackerBlack
        search.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        search.layer.cornerRadius = 16
        search.returnKeyType = .done
        search.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.trackerGray]
        )
        search.delegate = self
        return search
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.tintColor = .trackerBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            TrackerCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header"
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var placeholderImageView: UIImageView = {
        UIImageView(image: UIImage(named: "PlaceholderTracker"))
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
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

    func setView() {
        backgroundColor = .trackerWhite
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(searchStackView)
        addSubview(placeholderStackView)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchStackView.topAnchor.constraint(equalTo: topAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchStackView.heightAnchor.constraint(equalToConstant: 36),

            placeholderStackView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 34),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        didHiddenPlaceholder(placeholder: Placeholder.emptyCategories)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(recognizer)
    }

    // MARK: - Private methods

    func reloadData(newCategories: [TrackerCategory], placeholder: Placeholder) {
        visibleCategories = newCategories
        didHiddenPlaceholder(placeholder: placeholder)
        collectionView.reloadData()
    }

    private func didHiddenPlaceholder(placeholder: Placeholder) {
        placeholderStackView.isHidden = !visibleCategories.isEmpty

        switch placeholder {
        case .emptyCategories:
            placeholderImageView.image = UIImage(named: "PlaceholderTracker")
            placeholderLabel.text = "Что будем отслеживать?"
        case .notFoundCategories:
            placeholderImageView.image = UIImage(named: "SearchPlaceholder")
            placeholderLabel.text = "Ничего не найдено"
        }
    }

    @objc private func viewDidTap() {
        searchTextField.resignFirstResponder()
    }

    @objc private func cancelDidTap() {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        delegate?.reloadVisibleCategories(text: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewImp: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        visibleCategories[section].trackersList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.trackerService = trackerService
        cell.delegate = delegate as? TrackerCollectionCellDelegate
        cell.delegateView = self

        guard !visibleCategories.isEmpty else {
            return cell
        }

        let tracker = visibleCategories[indexPath.section].trackersList[indexPath.row]
        let isDone = delegate?.isTrackerCompleteToday(trackerId: tracker.id) ?? false
        cell.configure(
            newTracker: Tracker(
                id: tracker.id,
                name: tracker.name,
                color: tracker.color,
                emoji: tracker.emoji,
                schedule: tracker.schedule
            ),
            isDoneToday: isDone,
            completedDays: delegate?.countCompletedTracker(trackerId: tracker.id) ?? 0,
            indexPath: indexPath
        )
        delegate?.enableDoneButton { isEnable in
            cell.enabledDoneButton(isEnable: isEnable)
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as? TrackerCollectionHeaderView else {
            return UICollectionReusableView()
        }
        headerView.titleLabel.text = visibleCategories[indexPath.section].title
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewImp: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16.0, bottom: 20.0, right: 16.0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewImp: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - 42
        let cellWidth =  availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width - 44, height: 30)
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewImp: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButton.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = (searchTextField.text ?? "").lowercased()
        searchTextField.resignFirstResponder()
        delegate?.reloadVisibleCategories(text: text)
        return true
    }
}

// MARK: - TrackerCollectionCellViewDelegate

extension TrackersViewImp: TrackerCollectionCellViewDelegate {
    func reloadCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}
