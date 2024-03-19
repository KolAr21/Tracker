//
//  StatisticView.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

protocol StatisticView: UIView {
    var delegate: StatisticViewDelegate? { get set }

    func setView()
    func reload()
}

protocol StatisticViewDelegate: AnyObject {
    func setCountBestPeriod() -> String
    func setCountDay() -> String
    func setCountCompletedTracker() -> String
    func setMedian() -> String
}

final class StatisticViewImp: UIView, StatisticView {
    var delegate: StatisticViewDelegate?

    private var closures: [(() -> String)?] = []

    private let statistic: [String] = [
        NSLocalizedString("statistic.period", comment: "Text displayed on tracker"),
        NSLocalizedString("statistic.day", comment: "Text displayed on tracker"),
        NSLocalizedString("statistic.complete", comment: "Text displayed on tracker"),
        NSLocalizedString("statistic.median", comment: "Text displayed on tracker")
    ]

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: "StatisticCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var placeholderImageView: UIImageView = {
        UIImageView(image: UIImage(named: "PlaceholderStatistic"))
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistic.empty", comment: "Text displayed on tracker")
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
        closures = [
            delegate?.setCountBestPeriod,
            delegate?.setCountDay,
            delegate?.setCountCompletedTracker,
            delegate?.setMedian
        ]
        addSubview(collectionView)
        addSubview(placeholderStackView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),

            placeholderStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        placeholderStackView.isHidden = !(Int(delegate?.setCountCompletedTracker() ?? "0") == 0)
        collectionView.isHidden = (Int(delegate?.setCountCompletedTracker() ?? "0") == 0)
    }

    func reload() {
        placeholderStackView.isHidden = !(Int(delegate?.setCountCompletedTracker() ?? "0") == 0)
        collectionView.isHidden = (Int(delegate?.setCountCompletedTracker() ?? "0") == 0)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension StatisticViewImp: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        statistic.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StatisticCell",
            for: indexPath
        ) as? StatisticCollectionViewCell,
              let closure = closures[indexPath.row]
        else {
            return UICollectionViewCell()
        }

        cell.configure(count: closure(), name: statistic[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StatisticViewImp: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StatisticViewImp: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }
}
