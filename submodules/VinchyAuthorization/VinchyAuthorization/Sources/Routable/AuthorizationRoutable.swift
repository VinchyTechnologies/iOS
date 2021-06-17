//
//  AuthorizationRoutable.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 22.02.2021.
//

import UIKit

// MARK: - AuthorizationRoutable

public protocol AuthorizationRoutable: AnyObject {
  var viewController: UIViewController? { get }

  func presentAuthorizationViewController()
}

extension AuthorizationRoutable {
  public func presentAuthorizationViewController() {
    let controller: AuthorizationNavigationController = ChooseAuthTypeAssembly.assemblyModule()
    controller.authOutputDelegate = viewController as? AuthorizationOutputDelegate
    if UIDevice.current.userInterfaceIdiom == .pad {
      controller.modalPresentationStyle = .overFullScreen
    }
    viewController?.present(controller, animated: true, completion: nil)
  }
}
