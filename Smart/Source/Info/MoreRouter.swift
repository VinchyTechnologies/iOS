//
//  MoreRouter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import UIKit

protocol MoreRouterProtocol: AnyObject {
  func present(_ viewController: UIViewController, completion: (() -> Void)?)
  func pushToDocController()
  func pushToAboutController()
}

final class MoreRouter {
  
  weak var viewController: MoreViewController!
  
  init(viewController: MoreViewController) {
    self.viewController = viewController
  }
}

extension MoreRouter: MoreRouterProtocol {
  
  func pushToAboutController() {
    let controller = AboutViewController()
    controller.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(controller, animated: true)
  }
  
  func pushToDocController() {
    let controller = DocController()
    controller.hidesBottomBarWhenPushed = true
    viewController.navigationController?.pushViewController(controller, animated: true)
  }
  
  func present(_ viewController: UIViewController, completion: (() -> Void)?) {
    self.viewController.navigationController?.present(viewController, animated: true, completion: completion)
  }    
}
