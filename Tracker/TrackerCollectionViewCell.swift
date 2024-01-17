//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    var trackerService: TrackersService?
    private var tracker: Tracker?

    lazy var isDone: Bool = {
        guard let _ = trackerService?.completedTrackers.first(where: { $0.id == tracker?.id }) else {
            return false
        }
        return true
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.trackerWhite.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiLabel)
        return view
    }()

    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .trackerWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emojiView)
        stackView.addArrangedSubview(trackerLabel)
        return stackView
    }()

    private lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .trackerOrange
        topView.layer.cornerRadius = 16
        topView.addSubview(topStackView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlusTracker"), for: .normal)
        button.tintColor = .trackerOrange
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(doneButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(topView)
        contentView.addSubview(bottomStackView)

        NSLayoutConstraint.activate([
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),

            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 90),

            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),

            topStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            topStackView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            topStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            topStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),

            bottomStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            bottomStackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            bottomStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTracker(newTracker: Tracker) {
        tracker = newTracker
        emojiLabel.text = newTracker.emoji
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        trackerLabel.attributedText = NSMutableAttributedString(
            string: newTracker.name,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        dayLabel.text = newTracker.schedule
    }

    // MARK: - Private methods

    @objc private func didTapDoneButton(sender: UIButton!) {
        guard let tracker else {
            return
        }
        if !isDone {
            let image = UIImage(named: "DoneTracker")?.withTintColor(.trackerWhite)
            sender.setImage(image, for: .normal)
            sender.tintColor = .trackerWhite
            sender.layer.backgroundColor = UIColor.trackerOrange.withAlphaComponent(0.3).cgColor

            trackerService?.appendCompletedTracker(newTracker: TrackerRecord(id: 0, date: Date()))
            isDone = !isDone
        } else {
            sender.setImage(UIImage(named: "PlusTracker"), for: .normal)
            sender.tintColor = .trackerOrange
            sender.layer.backgroundColor = UIColor.clear.cgColor

            trackerService?.removeCompletedTracker(cell: tracker.id)
            isDone = !isDone
        }
    }
}
