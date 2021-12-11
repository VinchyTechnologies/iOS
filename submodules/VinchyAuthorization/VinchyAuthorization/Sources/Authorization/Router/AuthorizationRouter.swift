//
//  AuthorizationRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import VinchyUI

// MARK: - AuthorizationRouter

final class AuthorizationRouter {

  // MARK: Lifecycle

  init(
    input: AuthorizationInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AuthorizationInteractorProtocol?

  // MARK: Private

  private let input: AuthorizationInput
}

// MARK: AuthorizationRouterProtocol

extension AuthorizationRouter: AuthorizationRouterProtocol {
  func dismissWithSuccsessLogin(output: AuthorizationOutputModel?) {
    viewController?.navigationController?.dismiss(animated: true, completion: {
      (self.viewController?.navigationController as? AuthorizationNavigationController)?.authOutputDelegate?.didSuccessfullyLogin(output: output)
    })
  }

  func pushToEnterPasswordViewController(accountID: Int, password: String) {
    let controller = EnterPasswordAssembly.assemblyModule(input: .init(accountID: accountID, password: password))
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
}
