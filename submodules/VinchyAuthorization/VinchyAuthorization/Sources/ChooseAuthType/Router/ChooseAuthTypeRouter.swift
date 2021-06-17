//
//  ChooseAuthTypeRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import UIKit

// MARK: - ChooseAuthTypeRouter

final class ChooseAuthTypeRouter {

  // MARK: Lifecycle

  init(
    input: ChooseAuthTypeInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ChooseAuthTypeInteractorProtocol?

  // MARK: Private

  private let input: ChooseAuthTypeInput
}

// MARK: ChooseAuthTypeRouterProtocol

extension ChooseAuthTypeRouter: ChooseAuthTypeRouterProtocol {
  func pushAuthorizationViewController(mode: AuthorizationInput.AuthorizationMode) {
    viewController?.navigationController?.pushViewController(
      AuthorizationAssembly.assemblyModule(input: .init(mode: mode)),
      animated: true)
  }
}
