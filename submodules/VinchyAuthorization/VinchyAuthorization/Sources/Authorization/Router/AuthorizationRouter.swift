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
  
  func dismissWithSuccsessLogin(output: AuthorizationOutputModel?) {
    viewController?.navigationController?.dismiss(animated: true, completion: {
      (self.viewController?.navigationController as? AuthorizationNavigationController)?.authOutputDelegate?.didSuccessfullyLogin(output: output)
    })
  }
  
  func pushToEnterPasswordViewController(accountID: Int) {
    let controller = EnterPasswordAssembly.assemblyModule(input: .init(accountID: accountID))
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
}
