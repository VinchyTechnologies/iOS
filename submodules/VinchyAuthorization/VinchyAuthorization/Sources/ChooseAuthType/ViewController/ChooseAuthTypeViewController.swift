//
//  ChooseAuthTypeViewController.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import AuthenticationServices
import Core
import Display
import StringFormatting
import UIKit

// MARK: - ChooseAuthTypeViewController

final class ChooseAuthTypeViewController: UIViewController {

  // MARK: Internal

  var interactor: ChooseAuthTypeInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(closeSelf))

    view.backgroundColor = .mainBackground

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

    view.addSubview(appleIDButton)
    appleIDButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      appleIDButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
      appleIDButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      appleIDButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      appleIDButton.heightAnchor.constraint(equalToConstant: 48),
    ])

//    view.addSubview(registerButton)
//    registerButton.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -8),
//      registerButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//      registerButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//      registerButton.heightAnchor.constraint(equalToConstant: 48),
//    ])
//
//    view.addSubview(appleIDButton)
//    appleIDButton.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      appleIDButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -8),
//      appleIDButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//      appleIDButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//      appleIDButton.heightAnchor.constraint(equalToConstant: 48),
//    ])

//    if UIDevice.current.userInterfaceIdiom == .pad {
//      let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
//      swipeDown.direction = .down
//      view.addGestureRecognizer(swipeDown)
//    }

    interactor?.viewDidLoad()
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

  private lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .blueGray
    label.font = Font.regular(16)
    label.numberOfLines = 0

    let text = localized("agree_terms_of_use", bundle: Bundle(for: type(of: self)))
    label.text = text
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: localized("terms_of_use", bundle: Bundle(for: type(of: self))))
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: Font.medium(16), range: range1)
    underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.accent, range: range1)
    label.attributedText = underlineAttriString

    label.isUserInteractionEnabled = true
    label.lineBreakMode = .byWordWrapping
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
    tapGesture.numberOfTouchesRequired = 1
    label.addGestureRecognizer(tapGesture)

    return label
  }()

//  private lazy var registerButton: Button = {
//    let button = Button()
//    button.translatesAutoresizingMaskIntoConstraints = false
//    button.enable()
//    button.addTarget(self, action: #selector(didTapRegisterButton(_:)), for: .touchUpInside)
//    return button
//  }()
//
//  private lazy var loginButton: UIButton = {
//    let button = UIButton()
//    button.backgroundColor = .clear
//    button.setTitleColor(.accent, for: .normal)
//    button.titleLabel?.font = Font.bold(18)
//    button.clipsToBounds = true
//    button.layer.cornerCurve = .continuous
//    button.layer.cornerRadius = 24
//    button.layer.borderWidth = 2
//    button.layer.borderColor = UIColor.accent.cgColor
//    button.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
//    return button
//  }()

  private lazy var appleIDButton: ASAuthorizationAppleIDButton = {
    let appleIDButton = ASAuthorizationAppleIDButton(
      authorizationButtonType: .default,
      authorizationButtonStyle: UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black)
    appleIDButton.layer.cornerRadius = 24
    appleIDButton.clipsToBounds = true
    appleIDButton.addTarget(self, action: #selector(didTapAppleIDButton), for: .touchUpInside)
    return appleIDButton
  }()

  @objc
  private func closeSelf() {
    dismiss(animated: true)
  }

  @objc
  private func didTapAppleIDButton(_: UIButton) {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.email, .fullName]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }

  @objc
  private func didTapRegisterButton(_: UIButton) {
    interactor?.didTapRegisterButton()
  }

  @objc
  private func didTapLoginButton(_: UIButton) {
    interactor?.didTapLoginButton()
  }

  @objc
  private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
    guard let text = subtitleLabel.text else { return }
    let emailRange = (text as NSString).range(of: localized("terms_of_use", bundle: Bundle(for: type(of: self))))
    if gesture.didTapAttributedTextInLabel(label: subtitleLabel, inRange: emailRange) {
      openTerms()
    }
  }

  @objc
  private func didSwipeDown(_: UISwipeGestureRecognizer) {
    dismiss(animated: true)
  }

  private func openTerms() {
    open(urlString: localized("terms_of_use_url"), errorCompletion: {
      showAlert(title: localized("error").firstLetterUppercased(), message: localized("open_url_error"))
    })
  }
}

// MARK: ChooseAuthTypeViewControllerProtocol

extension ChooseAuthTypeViewController: ChooseAuthTypeViewControllerProtocol {
  func updateUI(viewModel: ChooseAuthTypeViewModel) {
    titleLabel.text = viewModel.titleText
//    subtitleLabel.text = viewModel.subtitleText
//    loginButton.setTitle(viewModel.loginButtonText, for: .normal)
//    registerButton.setTitle(viewModel.registerButtonText, for: .normal)
  }
}

// MARK: ASAuthorizationControllerDelegate

extension ChooseAuthTypeViewController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization)
  {
    switch authorization.credential {
    case let credentials as ASAuthorizationAppleIDCredential:

      guard let credentialsAuthorizationCode = credentials.authorizationCode else {
        fatalError("credentials.authorizationCode is nil")
      }

      guard let authorizationCode = String(data: credentialsAuthorizationCode, encoding: .utf8) else {
        fatalError("Can't read authorizationCode")
      }

      AuthService.shared.loginWithApple(
        email: credentials.email,
        fullName: credentials.fullName,
        appleUserId: credentials.user,
        authorizationCode: authorizationCode) { [weak self] result in
          switch result {
          case .success(let accountInfo):
            self?.navigationController?.dismiss(animated: true, completion: {
              (self?.navigationController as? AuthorizationNavigationController)?.authOutputDelegate?.didSuccessfullyLogin(output: .init(accountID: accountInfo.accountID, email: accountInfo.email))
            })

          case .failure(let error):
            self?.showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)
          }
      }

    default:
      break
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

    if let error = error as? ASAuthorizationError {
      switch error.code {
      case .unknown:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)

      case .canceled:
        break

      case .invalidResponse:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)

      case .notHandled:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)

      case .failed:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)

      case .notInteractive:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)

      @unknown default:
        showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)
      }
    } else {
      showAlert(title: localized("error").firstLetterUppercased(), message: error.localizedDescription)
    }
  }
}

// MARK: ASAuthorizationControllerPresentationContextProviding

extension ChooseAuthTypeViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    view.window! // swiftlint:disable:this force_unwrapping
  }
}
