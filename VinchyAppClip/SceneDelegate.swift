//
//  SceneDelegate.swift
//  VinchyAppClip
//
//  Created by Алексей Смирнов on 03.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
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
    
    let window = UIWindow(windowScene: windowScence)
    self.window = window
    window.rootViewController = VinchyNavigationController(
      rootViewController: StoreAssembly.assemblyModule(
        input: .init(mode: .normal(affilatedId: 366)),
        coordinator: Coordinator.shared))
    window.makeKeyAndVisible()
  }
}

