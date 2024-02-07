//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Арина Колганова on 22.01.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    lazy var colorView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ColorView")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var isSelected: Bool {
        didSet {
            colorView.image = isSelected ? UIImage(named: "ColorViewActive") : UIImage(named: "ColorView")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
