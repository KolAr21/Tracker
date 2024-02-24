//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 20.01.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    var viewModel: CategoryViewModel? {
        didSet {
            viewModel?.categoryLabelBinding = { [weak self] category in
                self?.label.text = category
            }
            viewModel?.categorySelectBinding = { [weak self] isSelect in
                self?.arrowImage.isHidden = !isSelect
            }
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .trackerBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "DoneTracker")
        image.tintColor = .trackerBlue
        image.isHidden = true
        return image
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(arrowImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "ScheduleCell")
        backgroundColor = .trackerBackground

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
