//
//  NameViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 06.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class NameViewController: UIViewController {

    let editingView = EditingStackView()
    let keyboardHelper = KeyboardHelper()

    lazy var bottomConstraint = NSLayoutConstraint(item: editingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground

        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(self.saveName))
//        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: Font.bold(20), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: UIControl.State.normal)
        navigationItem.rightBarButtonItem = rightBarButtonItem

        editingView.decorate(model: EditingStackViewModel(config: .name))
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

    @objc
    func showKeyboard() {
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

    @objc
    private func saveName() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

}
