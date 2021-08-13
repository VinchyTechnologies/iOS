//
//  AuthorizationInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Core
import StringFormatting
import VinchyCore

// MARK: - AuthorizationInteractor

final class AuthorizationInteractor {

  // MARK: Lifecycle

  init(
    input: AuthorizationInput,
    router: AuthorizationRouterProtocol,
    presenter: AuthorizationPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: AuthorizationInput
  private let router: AuthorizationRouterProtocol
  private let presenter: AuthorizationPresenterProtocol

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
}

// MARK: AuthorizationInteractorProtocol

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
  func didTapContinueButton(_ email: String?, password: String?) {

    guard let email = email else {
      presenter.updateInvalidEmailAndPassword()
      return
    }

    guard let password = password else {
      presenter.updateInvalidEmailAndPassword()
      return
    }

    if isValidEmail(email) && !password.isEmpty {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dispatchWorkItemHud.perform()
      }
      
      presenter.updateValidEmailAndPassword()

      switch input.mode {
      case .register:
        Accounts.shared.createNewAccount(email: email, password: password) { [weak self] result in
          guard let self = self else { return }
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }

          switch result {
          case .success(let accountID):
            self.presenter.endEditing()
            self.router.pushToEnterPasswordViewController(accountID: accountID.accountID, password: password)

          case .failure(let error):
            self.presenter.showCreateUserError(error: error)
          }
        }

      case .login:
        Accounts.shared.auth(email: email, password: password) { [weak self] result in
          guard let self = self else { return }
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }

          switch result {
          case .success(let model):
            self.presenter.endEditing()
            UserDefaultsConfig.accountEmail = model.email
            UserDefaultsConfig.accountID = model.accountID
            Keychain.shared.accessToken = model.accessToken
            Keychain.shared.refreshToken = model.refreshToken
            Keychain.shared.password = password
            self.router.dismissWithSuccsessLogin(output: .init(accountID: model.accountID, email: model.email))

          case .failure(let error):
            self.presenter.showLoginUserError(error: error)
          }
        }
      }
    } else {
      presenter.updateInvalidEmailAndPassword()
    }
  }

  func didEnterTextIntoEmailTextFieldOrPasswordTextField(_ email: String?, password: String?) {
    if isValidEmail(email), !(password?.isNilOrEmpty == true) {
      presenter.updateValidEmailAndPassword()
    } else {
      presenter.updateInvalidEmailAndPassword()
    }
  }

  func viewDidLoad() {
    presenter.update()
  }
}
