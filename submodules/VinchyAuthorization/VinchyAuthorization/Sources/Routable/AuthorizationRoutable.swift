//
//  AuthorizationRoutable.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 22.02.2021.
//

import UIKit

public protocol AuthorizationRoutable: AnyObject {

  var viewController: UIViewController? { get }

  func presentAuthorizationViewController()
}

public extension AuthorizationRoutable {

  func presentAuthorizationViewController() {
    let controller: AuthorizationNavigationController = ChooseAuthTypeAssembly.assemblyModule()
    controller.authOutputDelegate = viewController as? AuthorizationOutputDelegate
    viewController?.navigationController?.present(controller, animated: true, completion: nil)
  }
}
