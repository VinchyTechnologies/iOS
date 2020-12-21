//
//  AuthorizationPresenter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import Foundation

final class AuthorizationPresenter {
  
  private typealias ViewModel = AuthorizationViewModel
  
  weak var viewController: AuthorizationViewControllerProtocol?
  
  init(viewController: AuthorizationViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - AuthorizationPresenterProtocol

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
  
}
