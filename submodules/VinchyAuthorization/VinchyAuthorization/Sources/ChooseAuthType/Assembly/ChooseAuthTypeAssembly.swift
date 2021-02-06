//
//  ChooseAuthTypeAssembly.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 05.02.2021.
//

import Display
import UIKit

public final class ChooseAuthTypeAssembly {
  public static func assemblyModule() -> UIViewController {
    let viewController = ChooseAuthTypeViewController()
    
    let router = ChooseAuthTypeRouter(input: ChooseAuthTypeInput(), viewController: viewController)
    let presenter = ChooseAuthTypePresenter(viewController: viewController)
    let interactor = ChooseAuthTypeInteractor(router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
    
    let navigationController = NavigationController(rootViewController: viewController)
    
    return navigationController
  }
}
