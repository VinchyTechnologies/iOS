//
//  SceneDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CoreSpotlight
import Display
import FirebaseDynamicLinks
import UIKit
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

#if canImport(AdSupport)
import AdSupport
import Core
#endif
import GoogleMobileAds

// MARK: - SceneDelegate

final class SceneDelegate: UIResponder {

  // MARK: Internal

  var window: UIWindow?

  // MARK: Private

  private var savedShortCutItem: UIApplicationShortcutItem?
  private lazy var root: (RootInteractor & RootDeeplinkable) = {
    RootBuilderImpl(tabBarBuilder: TabBarBuilderImpl())
      .build(input: RootBuilderInput(window: window!)) // swiftlint:disable:this force_unwrapping
  }()

  private lazy var deeplinkRouter: DeeplinkRouter = {
    DeeplinkRouterImpl(root: root)
  }()

  @discardableResult
  private func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
    /**
     In this sample an alert is being shown to indicate that the action has been triggered,
     but in real code the functionality for the quick action would be triggered.
     */
    if let url = URL(string: shortcutItem.userInfo?["url"] as? String ?? "") {
      deeplinkRouter.route(url: url)
    }
    return true
  }
}

// MARK: UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {

  // MARK: Internal

  /** Called when the user activates your application by selecting a shortcut on the Home Screen,
   and the window scene is already connected.
   */
  /// - Tag: PerformAction
  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void)
  {
    let handled = handleShortCutItem(shortcutItem: shortcutItem)
    completionHandler(handled)
  }

//  func sceneDidBecomeActive(_ scene: UIScene) {
//    if let savedShortCutItem = savedShortCutItem {
//      handleShortCutItem(shortcutItem: savedShortCutItem)
//    }
//  }

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

//    if let shortcutItem = connectionOptions.shortcutItem {
//      // Save it off for later when we become active.
//      savedShortCutItem = shortcutItem
//    }
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // + 1.0 very important
      if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
//          GADMobileAds.sharedInstance().start(completionHandler: nil)
        })
      } else {
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
      }
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
    } else if
      userActivity.activityType == CSSearchableItemActionType,
      let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
      let url = URL(string: uniqueIdentifier)
    {
      deeplinkRouter.route(url: url)
    }
  }

  func scene(
    _: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>)
  {
    guard let urlToOpen = URLContexts.first?.url else { return }
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: urlToOpen) {
      handleIncomingDynamicLink(dynamicLink)
    } else {
      deeplinkRouter.route(url: urlToOpen)
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
