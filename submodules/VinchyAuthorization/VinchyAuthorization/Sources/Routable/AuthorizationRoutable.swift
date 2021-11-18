//
//  AuthorizationRoutable.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 22.02.2021.
//

import FittedSheets
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
    let options = SheetOptions(shrinkPresentingViewController: false)
    let sheetController = SheetViewController(
      controller: controller,
      sizes: [.fixed(350)],
      options: options)
    viewController?.present(sheetController, animated: true, completion: nil)
  }
}
