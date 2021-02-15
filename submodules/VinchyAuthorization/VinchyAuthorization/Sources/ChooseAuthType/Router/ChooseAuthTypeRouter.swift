//
//  ChooseAuthTypeRouter.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import UIKit

final class ChooseAuthTypeRouter {

    weak var viewController: UIViewController?
    weak var interactor: ChooseAuthTypeInteractorProtocol?
    private let input: ChooseAuthTypeInput

    init(
        input: ChooseAuthTypeInput,
        viewController: UIViewController)
    {
        self.input = input
        self.viewController = viewController
    }
}

// MARK: - ChooseAuthTypeRouterProtocol

extension ChooseAuthTypeRouter: ChooseAuthTypeRouterProtocol {
  
  func pushAuthorizationViewController(mode: AuthorizationInput.AuthorizationMode) {
    viewController?.navigationController?.pushViewController(
      AuthorizationAssembly.assemblyModule(input: .init(mode: mode)),
      animated: true)
  }
}
