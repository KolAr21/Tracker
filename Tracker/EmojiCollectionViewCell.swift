//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 22.01.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .trackerLightGray : .trackerWhite
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
