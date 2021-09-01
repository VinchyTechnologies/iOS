//
//  SceneDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import FirebaseDynamicLinks
import UIKit

// MARK: - SceneDelegate

final class SceneDelegate: UIResponder {

  // MARK: Internal

  // MARK: - Interanl Properties

  var window: UIWindow?

  // MARK: Private

  private lazy var root: (RootInteractor & RootDeeplinkable) = {
    RootBuilderImpl(tabBarBuilder: TabBarBuilderImpl())
      .build(input: RootBuilderInput(window: window!)) // swiftlint:disable:this force_unwrapping
  }()

  private lazy var deeplinkRouter: DeeplinkRouter = {
    DeeplinkRouterImpl(root: root)
  }()
}

// MARK: UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {

  // MARK: Internal

  func scene(
    _ scene: UIScene,
    willConnectTo _: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
    guard let windowScence = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScence)
    self.window = window
    root.startApp()

//    let mode = StoresInput(wineID: 891)
//    window.rootViewController = NavigationController(rootViewController: StoresAssembly.assemblyModule(input: mode))
//    window.makeKeyAndVisible()

    if let userActivity = connectionOptions.userActivities.first {
      self.scene(scene, continue: userActivity)
    } else {
      self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
  }

  func scene(
    _: UIScene,
    continue userActivity: NSUserActivity)
  {
    usleep(50000)
    if let incomingURL = userActivity.webpageURL {
      DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
        guard error == nil, let dynamicLink = dynamicLink else { return }
        self.handleIncomingDynamicLink(dynamicLink)
      }
    }
  }

  func scene(
    _: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>)
  {
    guard let urlToOpen = URLContexts.first?.url else { return }
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: urlToOpen) {
      handleIncomingDynamicLink(dynamicLink)
    }
  }

  // MARK: Private

  private func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
    guard
      let url = dynamicLink.url,
      dynamicLink.matchType == .unique || dynamicLink.matchType == .default
    else { return }

    deeplinkRouter.route(url: url)
  }
}
