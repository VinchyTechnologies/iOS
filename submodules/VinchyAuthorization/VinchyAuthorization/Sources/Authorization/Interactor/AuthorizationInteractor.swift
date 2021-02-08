//
//  AuthorizationInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import StringFormatting
import VinchyCore

final class AuthorizationInteractor {
  
  private let input: AuthorizationInput
  private let router: AuthorizationRouterProtocol
  private let presenter: AuthorizationPresenterProtocol
  
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  
  init(
    input: AuthorizationInput,
    router: AuthorizationRouterProtocol,
    presenter: AuthorizationPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - AuthorizationInteractorProtocol

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
  
  func didTapContinueButton(_ email: String?, password: String?) {
        
    guard let email = email else {
      presenter.updateInvalidEmailAndPassword()
      print("is invalid email")
      return
    }
    
    guard  let password = password else {
      presenter.updateInvalidEmailAndPassword() // TODO: -
      print("is invalid password")
      return
    }

    if isValidEmail(email) && !password.isEmpty {
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dispatchWorkItemHud.perform()
      }
      
      presenter.updateValidEmailAndPassword()
      print("is valid email")
      
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
            self.router.pushToEnterPasswordViewController(accountID: accountID.accountID)
            
          case .failure(let error):
            self.presenter.showCreateUserError(error: error)
          }
        }
          
      case .login:
        Accounts.shared.getAccount(email: email, password: password) { [weak self] result in
          guard let self = self else { return }
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }
          
          switch result {
          case .success(let accountID):
            self.presenter.endEditing()
            self.router.pushToEnterPasswordViewController(accountID: accountID.accountID)
            
          case .failure(let error):
            self.presenter.showLoginUserError(error: error)
          }
        }
      }
    } else {
      presenter.updateInvalidEmailAndPassword()
      print("is invalid email")
    }
  }
  
  func didEnterTextIntoEmailTextFieldOrPasswordTextField(_ email: String?, password: String?) {
    if isValidEmail(email) && !(password?.isEmpty == true) {
      presenter.updateValidEmailAndPassword()
    } else {
      presenter.updateInvalidEmailAndPassword()
    }
  }
  
  func viewDidLoad() {
    presenter.update()
  }
}
