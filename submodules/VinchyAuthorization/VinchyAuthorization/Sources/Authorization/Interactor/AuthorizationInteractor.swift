//
//  AuthorizationInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import StringFormatting
import VinchyCore

final class AuthorizationInteractor {
  
  private let router: AuthorizationRouterProtocol
  private let presenter: AuthorizationPresenterProtocol
  
  init(
    router: AuthorizationRouterProtocol,
    presenter: AuthorizationPresenterProtocol)
  {
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
      presenter.updateValidEmailAndPassword()
      print("is valid email")
      Accounts.shared.createNewAccount(email: email, password: password) { [weak self] result in
        switch result {
        case .success(let accountID):
          print(accountID.accountID)
          self?.presenter.endEditing()
          self?.router.pushToEnterPasswordViewController(accountID: accountID.accountID)
          
        case .failure(let error):
          self?.presenter.showCreateUserError(error: error)
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
