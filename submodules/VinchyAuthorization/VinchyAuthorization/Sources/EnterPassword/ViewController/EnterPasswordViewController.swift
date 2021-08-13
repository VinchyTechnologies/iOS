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

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

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
      passwordTextField.widthAnchor.constraint(equalToConstant: 280),
      passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      passwordTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
      passwordTextField.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -8),
    ])

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

  private lazy var passwordTextField: OTPStackView = {
    $0.delegate = self
    return $0
  }(OTPStackView())

  private lazy var continueButton: Button = {
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

  @objc
  private func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: UIApplication.shared.asKeyWindow)

    if notification.name == UIResponder.keyboardWillHideNotification {
      bottomConstraint.constant = 0
    } else {
      bottomConstraint.constant = -keyboardViewEndFrame.height - 10
    }
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapSendAgainButton(_: UIButton) {
    passwordTextField.clear()
    interactor?.didTapSendCodeAgainButton()
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
  }
}

// MARK: OTPDelegate

extension EnterPasswordViewController: OTPDelegate {
  func didChangeText(_ text: String) {
    interactor?.didEnterCodeInTextField(text)
  }
}
