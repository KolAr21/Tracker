//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

protocol TrackerCollectionCellDelegate: AnyObject {
    func completeTracker(id: UUID)
    func uncompleteTracker(id: UUID)
}

protocol TrackerCollectionCellViewDelegate: AnyObject {
    func reloadCell(indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    var trackerService: TrackersService?
    var delegate: TrackerCollectionCellDelegate?
    var delegateView: TrackerCollectionCellViewDelegate?

    private var tracker: Tracker?
    private var isDoneToday: Bool = false
    private var indexPath: IndexPath?

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

    func configure(newTracker: Tracker, isDoneToday: Bool, completedDays: Int, indexPath: IndexPath) {
        tracker = newTracker
        self.isDoneToday = isDoneToday
        self.indexPath = indexPath

        topView.backgroundColor = newTracker.color
        emojiLabel.text = newTracker.emoji
        doneButton.isEnabled = true
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        trackerLabel.attributedText = NSMutableAttributedString(
            string: newTracker.name,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        dayLabel.text = createStringWithCountDay(count: completedDays)

        if isDoneToday {
            let image = UIImage(named: "DoneTracker")?.withTintColor(.trackerWhite)
            doneButton.setImage(image, for: .normal)
            doneButton.tintColor = .trackerWhite
            doneButton.layer.backgroundColor = newTracker.color.withAlphaComponent(0.3).cgColor
        } else {
            doneButton.setImage(UIImage(named: "PlusTracker"), for: .normal)
            doneButton.layer.backgroundColor = UIColor.clear.cgColor
            doneButton.tintColor = newTracker.color
        }
    }

    func enabledDoneButton(isEnable: Bool) {
        guard let tracker, !isDoneToday else {
            return
        }

        doneButton.tintColor = isEnable ? tracker.color : tracker.color.withAlphaComponent(0.3)
        doneButton.isEnabled = isEnable ? true : false
    }

    // MARK: - Private methods

    private func createStringWithCountDay(count: Int) -> String {
        switch count {
        case 1:
            return "\(count) день"
        case 2,3,4:
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
    }

    @objc private func didTapDoneButton(sender: UIButton!) {
        guard let tracker, let indexPath else {
            return
        }

        isDoneToday ? delegate?.uncompleteTracker(id: tracker.id) : delegate?.completeTracker(id: tracker.id)
        delegateView?.reloadCell(indexPath: indexPath)
    }
}
