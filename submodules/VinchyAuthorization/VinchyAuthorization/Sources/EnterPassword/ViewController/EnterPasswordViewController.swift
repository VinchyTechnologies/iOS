//
//  EnterPasswordViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import Display
import UIKit

// MARK: - C

private enum C {
  private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
  static let eyeImage = UIImage(systemName: "eye", withConfiguration: imageConfig)
  static let eyeSlashImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
}

// MARK: - EnterPasswordViewController

final class EnterPasswordViewController: UIViewController {

  // MARK: Internal

  var interactor: EnterPasswordInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))

    view.addSubview(continueButton)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      continueButton.heightAnchor.constraint(equalToConstant: 48),
      bottomConstraint,
    ])

    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])

    view.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
    ])

    view.addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      passwordTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
      passwordTextField.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -8),
    ])

    configureKeyboardHelper()
    interactor?.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    passwordTextField.becomeFirstResponder()
  }

  // MARK: Private

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .accent
    label.font = Font.heavy(48)
    label.numberOfLines = 0
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .dark
    label.font = Font.bold(20)
    label.numberOfLines = 0
    return label
  }()

  private lazy var passwordTextField: TextField = {
    let textField = TextField()
    textField.delegate = self
    textField.keyboardType = .numberPad
    textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    return textField
  }()

  private let continueButton: Button = {
    let button = Button()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.disable()
    button.addTarget(self, action: #selector(didTapSendAgainButton(_:)), for: .touchUpInside)
    return button
  }()

  private lazy var bottomConstraint = NSLayoutConstraint(
    item: continueButton,
    attribute: .bottom,
    relatedBy: .equal,
    toItem: view,
    attribute: .bottom,
    multiplier: 1,
    constant: 0)

  private let keyboardHelper = KeyboardHelper()

  private func configureKeyboardHelper() {
    keyboardHelper.bindBottomToKeyboardFrame(
      animated: true,
      animate: { [weak self] height in
        self?.updateNextButtonBottomConstraint(with: height)
      })
  }

  private func updateNextButtonBottomConstraint(with keyboardHeight: CGFloat) {
    if keyboardHeight == 0 {
      bottomConstraint.constant = -keyboardHeight
    } else {
      bottomConstraint.constant = -keyboardHeight - 10
    }
    view.layoutSubviews()
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapSendAgainButton(_: UIButton) {
    interactor?.didTapSendCodeAgainButton()
  }

  @objc
  private func textFieldDidChange(_ textFiled: UITextField) {
    interactor?.didEnterCodeInTextField(textFiled.text)
  }
}

// MARK: EnterPasswordViewControllerProtocol

extension EnterPasswordViewController: EnterPasswordViewControllerProtocol {
  func updateUI(buttonText: String, isButtonEnabled: Bool) {
    continueButton.setTitle(buttonText, for: .normal)
    if isButtonEnabled {
      continueButton.enable()
    } else {
      continueButton.disable()
    }
  }

  func updateUI(viewModel: EnterPasswordViewModel) {
    titleLabel.text = viewModel.titleText
    subtitleLabel.text = viewModel.subtitleText
    passwordTextField.placeholder = viewModel.enterPasswordTextFiledPlaceholderText
    passwordTextField.selectedTitle = viewModel.enterPasswordTextFiledTopPlaceholderText
  }
}

// MARK: UITextFieldDelegate

extension EnterPasswordViewController: UITextFieldDelegate {}
