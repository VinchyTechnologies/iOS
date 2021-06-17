//
//  AuthorizationViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Display
import UIKit

// MARK: - C

private enum C {
  private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
  static let eyeImage = UIImage(systemName: "eye", withConfiguration: imageConfig)
  static let eyeSlashImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
}

// MARK: - AuthorizationViewController

final class AuthorizationViewController: UIViewController {

  // MARK: Internal

  var interactor: AuthorizationInteractorProtocol?


  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground

    edgesForExtendedLayout = []

    navigationItem.largeTitleDisplayMode = .never

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))

    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
      bottomConstraint,
    ])

    scrollView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])

    scrollView.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
    ])

    scrollView.addSubview(continueButton)
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      continueButton.heightAnchor.constraint(equalToConstant: 48),
      continueButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
    ])

    scrollView.addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      passwordTextField.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16),
    ])

    scrollView.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -16),
      emailTextField.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: 10),
    ])

    configureKeyboardHelper()
    interactor?.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
  }

  // MARK: Private

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .accent
    label.font = Font.heavy(48)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .dark
    label.font = Font.regular(16)
    label.numberOfLines = 0
    return label
  }()

  private lazy var emailTextField: TextField /* WithIcon */ = {
    let textField = TextField /* WithIcon */ ()
    textField.autocapitalizationType = .none
    textField.keyboardType = .emailAddress
//    textField.iconType = .image
//    textField.iconImage = UIImage(systemName: "envelope")
//    textField.iconMarginBottom = 0
//    textField.selectedIconColor = .blueGray

//    let imageView = UIImageView(image: UIImage(systemName: "envelope"))
//    imageView.tintColor = .blueGray
//    textField.rightView = imageView
//    textField.rightViewMode = .always
    textField.delegate = self
    textField.textContentType = .emailAddress
    textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    return textField
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
    textField.rightViewMode = .always
    textField.rightView = eyeButton
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
    item: scrollView,
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
    bottomConstraint.constant = -keyboardHeight
    view.layoutSubviews()
  }

  @objc
  private func didTapContinueButton(_: UIButton) {
    interactor?.didTapContinueButton(emailTextField.text, password: passwordTextField.text)
  }

  @objc
  private func textFieldDidChange(_ textFieled: UITextField) {
    if textFieled === emailTextField {
      textFieled.text = textFieled.text?.lowercased()
    }

    interactor?.didEnterTextIntoEmailTextFieldOrPasswordTextField(
      emailTextField.text?.lowercased(),
      password: passwordTextField.text)
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapEyeButton(_: UIButton) {
    passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    if passwordTextField.isSecureTextEntry {
      eyeButton.setImage(C.eyeImage, for: .normal)
    } else {
      eyeButton.setImage(C.eyeSlashImage, for: .normal)
    }
  }
}

// MARK: AuthorizationViewControllerProtocol

extension AuthorizationViewController: AuthorizationViewControllerProtocol {
  func endEditing() {
    view.endEditing(true)
  }

  func updateUI(viewModel: AuthorizationViewModel) {
    titleLabel.text = viewModel.titleText
    subtitleLabel.text = viewModel.subtitleText
    emailTextField.placeholder = viewModel.emailTextFiledPlaceholderText
    emailTextField.selectedTitle = viewModel.emailTextFiledTopPlaceholderText
    passwordTextField.placeholder = viewModel.passwordTextFiledPlaceholderText
    passwordTextField.selectedTitle = viewModel.passwordTextFiledTopPlaceholderText
    continueButton.setTitle(viewModel.continueButtonText, for: .normal)
  }

  func updateUIValidEmailAndPassword() {
    continueButton.enable()
  }

  func updateUIInvalidEmailAndPassword() {
    continueButton.disable()
  }
}

// MARK: UITextFieldDelegate

extension AuthorizationViewController: UITextFieldDelegate {
  //  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    interactor?.didTapContinueButton(textField.text)
//    return true
  //  }
}
