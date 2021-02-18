//
//  RootRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

protocol RootRouter {
  func routeToTabBar() -> TabBarDeeplinkable
  func routeToAgreement(delegate: AgreementsViewControllerOutput)
  func routeToOnboarding(delegate: OnboardingViewControllerOutput?)
}

final class RootRouterImpl: RootRouter {
  
  private let window: UIWindow
  private let tabBarBuilder: TabBarBuilder
  
  init(window: UIWindow, tabBarBuilder: TabBarBuilder) {
    self.window = window
    self.tabBarBuilder = tabBarBuilder
    self.window.makeKeyAndVisible()
  }
  
  func routeToTabBar() -> TabBarDeeplinkable {
    
    if window.rootViewController is TabBarController {
      return window.rootViewController as! TabBarController // swiftlint:disable:this force_cast
    }
    
    let tabBar = tabBarBuilder.build()
    window.rootViewController = tabBar
    return tabBar
  }
  
  func routeToAgreement(delegate: AgreementsViewControllerOutput) {
    let vc = AgreementsModuleFactory().makeAgreementsViewController(delegate: delegate)
    window.rootViewController = vc
  }
  
  func routeToOnboarding(delegate: OnboardingViewControllerOutput?) {
    let vc = OnboardingModuleFactory().makeOnboardingViewController(delegate: delegate)
    window.rootViewController = vc
  }
}

final class AgreementsModuleFactory {

  func makeAgreementsViewController(
    delegate: AgreementsViewControllerOutput?)
    -> AgreementsViewController
  {
    let viewController = AgreementsViewController()
    viewController.delegate = delegate
    return viewController
  }
}
