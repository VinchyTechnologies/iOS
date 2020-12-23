//
//  AuthorizationInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import StringFormatting

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
  
  func didTapContinueButton(_ email: String?) {
    if isValidEmail(email) {
      presenter.updateValidEmail()
      print("is valid email")
      router.pushToEnterPasswordViewController()
    } else {
      presenter.updateInvalidEmail()
      print("is invalid email")
    }
  }
  
  func didEnterTextIntoEmailTextField(_ email: String?) {
    if isValidEmail(email) {
      presenter.updateValidEmail()
    } else {
      presenter.updateInvalidEmail()
    }
  }
  
  func viewDidLoad() {
    presenter.update()
  }
}
