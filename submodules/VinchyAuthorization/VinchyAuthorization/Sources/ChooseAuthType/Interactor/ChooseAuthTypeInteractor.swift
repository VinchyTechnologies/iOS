//
//  ChooseAuthTypeInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Foundation

final class ChooseAuthTypeInteractor {
  
  private let router: ChooseAuthTypeRouterProtocol
  private let presenter: ChooseAuthTypePresenterProtocol
  
  init(
    router: ChooseAuthTypeRouterProtocol,
    presenter: ChooseAuthTypePresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - ChooseAuthTypeInteractorProtocol

extension ChooseAuthTypeInteractor: ChooseAuthTypeInteractorProtocol {
  
  func viewDidLoad() {
    presenter.update()
  }
  
  func didTapRegisterButton() {
    router.pushAuthorizationViewController(mode: .register)
  }
  
  func didTapLoginButton() {
    router.pushAuthorizationViewController(mode: .login)
  }
}
