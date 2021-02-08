//
//  EnterPasswordRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import UIKit

final class EnterPasswordRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: EnterPasswordInteractorProtocol?
  private let input: EnterPasswordInput
  
  init(
    input: EnterPasswordInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - EnterPasswordRouterProtocol

extension EnterPasswordRouter: EnterPasswordRouterProtocol {
  func dismissAndRequestSuccess() {
    viewController?.navigationController?.dismiss(animated: true, completion: {
      (self.viewController?.navigationController as? AuthorizationNavigationController)?.authOutputDelegate?.didSuccessfullyRegister(output: nil)
    })
  }
}
