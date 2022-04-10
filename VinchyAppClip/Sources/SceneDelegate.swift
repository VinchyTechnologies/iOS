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
//      userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL
    else {
      let window = UIWindow(windowScene: windowScence)
      self.window = window
      window.rootViewController = VinchyNavigationController(
        rootViewController: StoreAssembly.assemblyModule(
          input: .init(mode: .normal(affilatedId: 1529), isAppClip: true),
          coordinator: Coordinator.shared, adFabricProtocol: nil))
      window.makeKeyAndVisible()
      return
    }

    if
      var components = URLComponents(string: url.absoluteString.removingPercentEncoding ?? ""),
      let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
      let affilatedId = Int(id)
    {
      components.queryItems = nil
      if let word = URL(string: components.string ?? "")?.lastPathComponent, word == "stores" {
        let window = UIWindow(windowScene: windowScence)
        self.window = window
        window.rootViewController = VinchyNavigationController(
          rootViewController: StoreAssembly.assemblyModule(
            input: .init(mode: .normal(affilatedId: affilatedId), isAppClip: true),
            coordinator: Coordinator.shared, adFabricProtocol: nil))
        window.makeKeyAndVisible()
      }
    } else {
      let window = UIWindow(windowScene: windowScence)
      self.window = window
      window.rootViewController = VinchyNavigationController(
        rootViewController: StoreAssembly.assemblyModule(
          input: .init(mode: .normal(affilatedId: 1529), isAppClip: true),
          coordinator: Coordinator.shared, adFabricProtocol: nil))
      window.makeKeyAndVisible()
    }
  }
}
