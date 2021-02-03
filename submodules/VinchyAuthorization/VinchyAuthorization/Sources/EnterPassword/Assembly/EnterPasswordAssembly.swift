//
//  EnterPasswordAssembly.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 23.12.2020.
//

import UIKit

final class EnterPasswordAssembly {
  
  static func assemblyModule(input: EnterPasswordInput) -> UIViewController {
    let viewController = EnterPasswordViewController()
    
    let router = EnterPasswordRouter(input: input, viewController: viewController)
    let presenter = EnterPasswordPresenter(viewController: viewController)
    let interactor = EnterPasswordInteractor(input: input, router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
        
    return viewController
  }
}
