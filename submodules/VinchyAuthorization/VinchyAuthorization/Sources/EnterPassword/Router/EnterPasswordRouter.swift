//
//  EnterPasswordRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import UIKit
import VinchyCore
import VinchyUI

// MARK: - EnterPasswordRouter

final class EnterPasswordRouter {

  // MARK: Lifecycle

  init(
    input: EnterPasswordInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: EnterPasswordInteractorProtocol?

  // MARK: Private

  private let input: EnterPasswordInput
}

// MARK: EnterPasswordRouterProtocol

extension EnterPasswordRouter: EnterPasswordRouterProtocol {
  func dismissAndRequestSuccess(output: AuthorizationOutputModel?) {
    viewController?.navigationController?.dismiss(animated: true, completion: {
      (self.viewController?.navigationController as? AuthorizationNavigationController)?.authOutputDelegate?.didSuccessfullyRegister(output: output)
    })
  }
}
