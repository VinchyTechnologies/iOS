//
//  MoreRouter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import Display
import UIKit

final class MoreRouter {
  
  weak var viewController: MoreViewController?
  private let emailService = EmailService()
  
  init(viewController: MoreViewController) {
    self.viewController = viewController
  }
}

extension MoreRouter: MoreRouterProtocol {
  
  func presentShowEditProfileViewController() {
    let controller = NavigationController(rootViewController: EditProfileAssembly.assemblyModule()) 
    viewController?.present(controller, animated: true)
  }
  
  func pushToCurrencyViewController() {
    let controller = CurrencyAssembly.assemblyModule()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func presentEmailController(HTMLText: String?, recipients: [String]) {
    let emailController = emailService.getEmailController(
      HTMLText: HTMLText,
      recipients: recipients)
    viewController?.present(emailController, animated: true, completion: nil)
  }
  
  func pushToAboutController() {
    let controller = AboutViewController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func pushToDocController() {
    let controller = DocController()
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
  
  func present(_ viewController: UIViewController, completion: (() -> Void)?) {
    self.viewController?.navigationController?.present(viewController, animated: true, completion: completion)
  }
}
