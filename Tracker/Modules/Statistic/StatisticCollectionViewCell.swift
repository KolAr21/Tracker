//
//  StatisticCollectionViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 17.03.2024.
//

import UIKit

final class StatisticCollectionViewCell: UICollectionViewCell {
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .trackerFontBlack
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trackerFontBlack
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 7
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = [UIColor.trackerGradientRed.cgColor, UIColor.trackerGradientGreen.cgColor, UIColor.trackerGradientBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        let shape = CALayer()
        shape.frame =  CGRect(origin: .zero, size: frame.size)
        shape.cornerRadius = 16
        shape.backgroundColor = UIColor.trackerWhite.cgColor
        shape.masksToBounds = true
        shape.addSublayer(gradient)

        clipsToBounds = true
        contentView.layer.insertSublayer(shape, at: 0)
        let view = UIView()
        view.backgroundColor = .trackerWhite
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(count: String, name: String) {
        countLabel.text = count
        nameLabel.text = name
    }
}
