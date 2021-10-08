//
//  RootRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - RootRouter

protocol RootRouter {
  func routeToTabBar() -> TabBarDeeplinkable
  func routeToAgreement(delegate: AgreementsViewControllerOutput)
  func routeToOnboarding(delegate: OnboardingViewControllerOutput?)
}

// MARK: - RootRouterImpl

final class RootRouterImpl: RootRouter {

  // MARK: Lifecycle

  init(window: UIWindow, tabBarBuilder: TabBarBuilder) {
    self.window = window
    self.tabBarBuilder = tabBarBuilder
    self.window.makeKeyAndVisible()
  }

  // MARK: Internal

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
//    window.rootViewController = vc
    setRootViewController(window: window, viewController: vc)
  }

  // MARK: Private

  private let window: UIWindow
  private let tabBarBuilder: TabBarBuilder

  private func setRootViewController(window: UIWindow, viewController: UIViewController, animated: Bool = true) {
    guard animated else {
      window.rootViewController = viewController
      window.makeKeyAndVisible()
      return
    }

    // TODO: - animation push

    window.rootViewController = viewController
    window.makeKeyAndVisible()
    UIView.transition(
      with: window,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: nil,
      completion: nil)
  }
}

// MARK: - AgreementsModuleFactory

final class AgreementsModuleFactory {
  func makeAgreementsViewController(
    delegate: AgreementsViewControllerOutput?)
    -> NewAgreementViewController
  {
    let viewController = NewAgreementViewController()
    viewController.delegate = delegate
    return viewController
  }
}
