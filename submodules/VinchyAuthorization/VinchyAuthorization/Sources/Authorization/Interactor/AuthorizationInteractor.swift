//
//  AuthorizationInteractor.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

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
  
  func viewDidLoad() {
    
  }
}
