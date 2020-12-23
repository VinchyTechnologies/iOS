//
//  EnterPasswordViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import UIKit
import Display

fileprivate enum C {
  private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
  static let eyeImage = UIImage(systemName: "eye", withConfiguration: imageConfig)
  static let eyeSlashImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
}

final class EnterPasswordViewController: UIViewController {
  
  // MARK: - Internal Properties
  
  var interactor: EnterPasswordInteractorProtocol?
  
  // MARK: - Private Properties
  
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
  
  private lazy var eyeButton: UIButton = {
    let button = UIButton()
    button.tintColor = .blueGray
    button.setImage(C.eyeImage, for: .normal)
    button.addTarget(self, action: #selector(didTapEyeButton(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var passwordTextField: TextField = {
    let textField = TextField()
    textField.delegate = self
//    textField.textContentType = .password // TODO: -
    textField.rightViewMode = .always
    textField.rightView = eyeButton
    textField.keyboardType = .numberPad
    textField.isSecureTextEntry = true
    textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    return textField
  }()
  
  private let continueButton: Button = {
    let button = Button()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.disable()
    button.addTarget(self, action: #selector(didTapContinueButton(_:)), for: .touchUpInside)
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
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never
        
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
  
  // MARK: - Private Methods
  
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
  private func didTapContinueButton(_ button: UIButton) {
//    interactor?.didTapContinueButton(emailTextField.text)
  }
  
  @objc
  private func textFieldDidChange(_ textFiled: UITextField) {
//    interactor?.didEnterTextIntoEmailTextField(textFiled.text)
  }
  
  @objc
  private func didTapForgotButton() {
    
  }
  
  @objc
  private func didTapEyeButton(_ button: UIButton) {
    passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    if passwordTextField.isSecureTextEntry {
      eyeButton.setImage(C.eyeImage, for: .normal)
    } else {
      eyeButton.setImage(C.eyeSlashImage, for: .normal)
    }
  }
}

// MARK: - EnterPasswordViewControllerProtocol

extension EnterPasswordViewController: EnterPasswordViewControllerProtocol {
  
  func updateUI(viewModel: EnterPasswordViewModel) {
    titleLabel.text = viewModel.titleText
    subtitleLabel.text = viewModel.subtitleText
    passwordTextField.placeholder = viewModel.enterPasswordTextFiledPlaceholderText
    passwordTextField.selectedTitle = viewModel.enterPasswordTextFiledTopPlaceholderText
    continueButton.setTitle(viewModel.continueButtonText, for: .normal)
    
//    navigationItem.rightBarButtonItem = UIBarButtonItem(
//      title: viewModel.rightBarButtonItemText,
//      style: .plain,
//      target: self,
//      action: #selector(didTapForgotButton))
  }
}

// MARK: - UITextFieldDelegate

extension EnterPasswordViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    interactor?.didTapContinueButton(textField.text)
    return true
  }
}
