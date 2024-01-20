//
//  TrackersView.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

protocol TrackersView: UIView {
    var trackerService: TrackersService? { get set }
    var categoriesForView: [TrackerCategory] { get set }
    var search: UISearchController { get }

    func setView()
    func reloadData()
}

final class TrackersViewImp: UIView, TrackersView {
    var trackerService: TrackersService?
    var categoriesForView: [TrackerCategory] = []

    var search: UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        return search
    }

    lazy var collectionView: UICollectionView = {
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

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        if (trackerService?.categories.isEmpty) != nil {
            addSubview(placeholderStackView)

            NSLayoutConstraint.activate([
                placeholderStackView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                placeholderStackView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            ])
        }
    }

    func reloadData() {
        placeholderStackView.isHidden = ((trackerService?.categories.isEmpty) != nil)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewImp: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categoriesForView.count
        //trackerService?.categories.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categoriesForView[section].trackersList.count
        //trackerService?.categories[section].trackersList.count ?? 0
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

        guard !categoriesForView.isEmpty/*let tracker = trackerService?.categories[indexPath.section].trackersList[indexPath.row]*/ else {
            return cell
        }
        let tracker = categoriesForView[indexPath.section].trackersList[indexPath.row]
        cell.setTracker(newTracker: Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule
        ))
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
        headerView.titleLabel.text = categoriesForView[indexPath.section].title //trackerService?.categories[indexPath.section].title
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
        UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
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
        CGSize(width: collectionView.frame.width - 44, height: 42)
    }
}

extension TrackersViewImp: UISearchControllerDelegate {

}
