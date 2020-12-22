//
//  AuthorizationViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import Display

final class AuthorizationViewController: UIViewController {
  
  // MARK: - Internal Properties
  
  var interactor: AuthorizationInteractorProtocol?
  
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
    label.font = Font.regular(20)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var emailTextField: TextField = {
    let textField = TextField()
    textField.keyboardType = .emailAddress
    textField.iconType = .image
    textField.iconImage = UIImage(systemName: "envelope")
    textField.iconMarginBottom = 0
    textField.selectedIconColor = .blueGray
    textField.delegate = self
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
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))
        
    view.addSubview(continueButton)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      continueButton.heightAnchor.constraint(equalToConstant: 48),
      bottomConstraint,
    ])
    
    view.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      emailTextField.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16),
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
      subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: emailTextField.topAnchor, constant: -8),
    ])
    
    configureKeyboardHelper()
    interactor?.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
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
    interactor?.didTapContinueButton(emailTextField.text)
  }
  
  @objc
  private func textFieldDidChange(_ textFiled: UITextField) {
    interactor?.didEnterTextIntoEmailTextField(textFiled.text)
  }
  
  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }
}

// MARK: - AuthorizationViewControllerProtocol

extension AuthorizationViewController: AuthorizationViewControllerProtocol {
  
  func updateUI(viewModel: AuthorizationViewModel) {
    titleLabel.text = viewModel.titleText
    subtitleLabel.text = viewModel.subtitleText
    emailTextField.placeholder = viewModel.emailTextFiledPlaceholderText
    emailTextField.selectedTitle = viewModel.emailTextFiledTopPlaceholderText
    continueButton.setTitle(viewModel.continueButtonText, for: .normal)
  }
  
  func updateUIValidEmail() {
    continueButton.enable()
  }
  
  func updateUIInvalidEmail() {
    continueButton.disable()
  }
}

// MARK: - UITextFieldDelegate

extension AuthorizationViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    interactor?.didTapContinueButton(textField.text)
    return true
  }
}
