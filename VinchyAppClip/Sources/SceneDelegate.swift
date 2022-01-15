//
//  SceneDelegate.swift
//  VinchyAppClip
//
//  Created by Алексей Смирнов on 03.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit
import VinchyStore

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
    guard let windowScence = scene as? UIWindowScene else { return }

    guard
      let userActivity = connectionOptions.userActivities.first,
      userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL
    else {
      return
    }

    guard
      let word = url.pathComponents[safe: url.pathComponents.count - 2],
      word == "store",
      let id = url.pathComponents.last,
      let affilatedId = Int(id)
    else { return }

    let window = UIWindow(windowScene: windowScence)
    self.window = window
    window.rootViewController = VinchyNavigationController(
      rootViewController: StoreAssembly.assemblyModule(
        input: .init(mode: .normal(affilatedId: affilatedId), isAppClip: true),
        coordinator: Coordinator.shared, adFabricProtocol: nil))
    window.makeKeyAndVisible()
  }
}
