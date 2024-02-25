//
//  NewCategoryView.swift
//  Tracker
//
//  Created by Арина Колганова on 07.02.2024.
//

import UIKit

protocol NewCategoryView: UIView {
    var delegate: NewCategoryViewDelegate? { get set }

    func setView()
}

protocol NewCategoryViewDelegate: AnyObject {
    func addCategory(newCategory: String)
    func dismissVC()
}

final class NewCategoryViewImp: UIView, NewCategoryView {
    var delegate: NewCategoryViewDelegate?

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("newCategory.namePlaceholder", comment: "Text displayed on tracker"),
            attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.trackerGray,
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        )
        textField.delegate = self
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .trackerBackground
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.setTitleColor(.trackerWhite, for: .normal)
        button.setTitle(NSLocalizedString("newCategory.button", comment: "Text displayed on tracker"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()

    func setView() {
        backgroundColor = .trackerWhite

        addSubview(categoryTextField)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            categoryTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            categoryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),

            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        recognizer.cancelsTouchesInView = false
        addGestureRecognizer(recognizer)
    }

    // MARK: - Private methods

    @objc private func viewDidTap() {
        categoryTextField.resignFirstResponder()
    }

    @objc private func addNewCategory() {
        guard let text = categoryTextField.text else {
            return
        }

        delegate?.addCategory(newCategory: text)
        delegate?.dismissVC()
    }

    private func isEnableButton() {
        guard let text = categoryTextField.text, !text.isEmpty else {
            addButton.isUserInteractionEnabled = false
            addButton.backgroundColor = .trackerGray
            return
        }

        addButton.isUserInteractionEnabled = true
        addButton.backgroundColor = .trackerBlack
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewImp: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isEnableButton()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryTextField.resignFirstResponder()
        addNewCategory()
        return false
    }
}
