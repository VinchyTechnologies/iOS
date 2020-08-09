//
//  EmailViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class EmailViewController: UIViewController, Alertable {

    var authCompletion: (() -> Void)?

    private let editingView = EditingStackView()
    private let keyboardHelper = KeyboardHelper()

    private lazy var bottomConstraint = NSLayoutConstraint(item: editingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground

        let rightBarButtonItem = UIBarButtonItem(title: "Далее", style: .plain, target: self, action: #selector(nextStep))
        navigationItem.rightBarButtonItem = rightBarButtonItem

        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "x"), style: .plain, target: self, action: #selector(closeModule))
        navigationItem.leftBarButtonItem = leftBarButtonItem

        editingView.decorate(model: EditingStackViewModel(config: .email))
        view.addSubview(editingView)
        editingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editingView.heightAnchor.constraint(equalToConstant: 180),
            bottomConstraint
        ])
        configureKeyboardHelper()

        NotificationCenter.default.addObserver(self, selector:#selector(showKeyboard),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showKeyboard()
    }

    @objc private func showKeyboard() {
        editingView.textField.becomeFirstResponder()
    }

    private func configureKeyboardHelper() {
        keyboardHelper.bindBottomToKeyboardFrame(
            animated: true,
            animate: { [weak self] height in
                self?.updateNextButtonBottomConstraint(with: height)
        })
    }

    public func updateNextButtonBottomConstraint(with keyboardHeight: CGFloat) {
        if keyboardHeight == 0 { return }
        bottomConstraint.constant = -keyboardHeight - 10
        view.layoutSubviews()
    }

    @objc private func nextStep() {

        guard let email = editingView.textField.text, !email.isEmpty else {
            showAlert(message: "Email не должен быть пустым")
            return
        }

        if isValidEmail(email) {
            view.endEditing(true)
            navigationController?.pushViewController(PasswordViewController(), animated: true)
        } else {
            showAlert(message: "Не верный email")
        }

    }

    @objc private func closeModule() {
        dismiss(animated: true, completion: nil)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
