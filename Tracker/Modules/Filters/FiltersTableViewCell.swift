//
//  FiltersTableViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 16.03.2024.
//

import UIKit

final class FiltersTableViewCell: UITableViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .trackerFontBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    lazy var arrowImage: UIImageView = {
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
        super.init(style: .subtitle, reuseIdentifier: "FilterCell")
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

    func configure(filter: String, isSelect: Bool) {
        label.text = filter
        arrowImage.isHidden = isSelect
    }
}
