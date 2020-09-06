//
//  PasswordViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class PasswordViewController: UIViewController {

    private let editingView = EditingStackView()
    private let keyboardHelper = KeyboardHelper()
    private lazy var bottomConstraint = NSLayoutConstraint(item: editingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground

        let leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backStep))
        navigationItem.leftBarButtonItem = leftBarButtonItem

        editingView.decorate(model: EditingStackViewModel(config: .password))
        editingView.bottomButton.setTitle("Зарегистрироваться", for: .normal)
        view.addSubview(editingView)
        editingView.textField.isSecureTextEntry = true
        editingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editingView.heightAnchor.constraint(equalToConstant: 250),
            bottomConstraint
        ])
        configureKeyboardHelper()
        editingView.textField.becomeFirstResponder()
    }

    private func configureKeyboardHelper() {
        keyboardHelper.bindBottomToKeyboardFrame(
            animated: true,
            animate: { [weak self] height in
                self?.updateNextButtonBottomConstraint(with: height)
        })
    }

    private func updateNextButtonBottomConstraint(with keyboardHeight: CGFloat) {
        if keyboardHeight == 0 { return }
        bottomConstraint.constant = -keyboardHeight - 10
        view.layoutSubviews()
    }

    @objc
    private func backStep() {
        navigationController?.popViewController(animated: true)
    }

}
