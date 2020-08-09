//
//  EditingStackView.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 02.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public enum EditingStackViewConfiguration {
    
    case name, email, password

    var topLabelText: String? {
        switch self {
        case .name:
            return "Как к Вам обращаться?"
        case .email:
            return "Давай знакомиться 🤪"
        case .password:
            return "Придумайте пароль 🧐"
        }
    }

    var keyBoardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .password:
            return .default
        case .name:
            return .default
        }
    }

    var placeholder: String? {
        switch self {
        case .name:
            return ""
        case .email:
            return "email@mail.com"
        case .password:
            return "qwerty"
        }
    }
}

public struct EditingStackViewModel : ViewModelProtocol {
    let config: EditingStackViewConfiguration

    public init(config: EditingStackViewConfiguration) {
        self.config = config
    }
}

final public class EditingStackView: UIView {

    // MARK: - Public Properties

    public lazy var textField = UITextField()
    public lazy var bottomButton = UIButton()
    public lazy var forgotButton = UIButton()

    // MARK: - Private Properties

    private let stackView = UIStackView()
    private let topLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        topLabel.textColor = .dark
        topLabel.font = Font.bold(24)
        textField.font = Font.bold(40)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private Methods

    private func buildPhoneViews() {
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(textField)
    }

    private func buildSMSViews() {
        bottomButton.backgroundColor = .dark
        bottomButton.layer.cornerRadius = 22
        bottomButton.setTitleColor(.white, for: .normal)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bottomButton.titleLabel?.font = Font.bold(16)//UIFont(name: FontName.DinBold, size: 16)

        forgotButton.setTitle("Забыли пароль?", for: .normal)
        forgotButton.setTitleColor(.blueGray, for: .normal)
        forgotButton.titleLabel?.font = Font.bold(16)//UIFont(name: FontName.DinBold, size: 16)

        stackView.setCustomSpacing(10, after: textField)

        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(bottomButton)
        stackView.addArrangedSubview(forgotButton)
    }

    private func buildNameViews() {
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(textField)
    }

}

extension EditingStackView : Decoratable {

    public typealias ViewModel = EditingStackViewModel

    public func decorate(model: EditingStackViewModel) {
        topLabel.text = model.config.topLabelText
        textField.keyboardType = model.config.keyBoardType
        textField.placeholder = model.config.placeholder

        switch model.config {
        case .email:
            buildPhoneViews()
        case .password:
            buildSMSViews()
        case .name:
            buildNameViews()
        }
    }
}
