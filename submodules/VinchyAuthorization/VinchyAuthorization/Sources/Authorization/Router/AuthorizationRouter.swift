//
//  AuthorizationRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit

final class AuthorizationRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: AuthorizationInteractorProtocol?
  private let input: AuthorizationInput
  
  init(
    input: AuthorizationInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - AuthorizationRouterProtocol

extension AuthorizationRouter: AuthorizationRouterProtocol {
  
}
