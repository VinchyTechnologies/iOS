//
//  AuthorizationAssembly.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import Display

final class AuthorizationAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = AuthorizationViewController()
    
    let router = AuthorizationRouter(input: AuthorizationInput(), viewController: viewController)
    let presenter = AuthorizationPresenter(viewController: viewController)
    let interactor = AuthorizationInteractor(router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
    
    let navigationController = NavigationController(rootViewController: viewController)
    
    return navigationController
  }
}
