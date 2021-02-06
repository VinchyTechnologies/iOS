//
//  AuthorizationAssembly.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit
import Display

final class AuthorizationAssembly {
  static func assemblyModule(input: AuthorizationInput) -> UIViewController {
    
    let viewController = AuthorizationViewController()
    
    let router = AuthorizationRouter(input: input, viewController: viewController)
    let presenter = AuthorizationPresenter(viewController: viewController)
    let interactor = AuthorizationInteractor(input: input, router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
        
    return viewController
  }
}
