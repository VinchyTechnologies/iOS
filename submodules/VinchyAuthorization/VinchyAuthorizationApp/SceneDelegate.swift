//
//  SceneDelegate.swift
//  VinchyAuthorizationApp
//
//  Created by Алексей Смирнов on 21.12.2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
    guard let _ = (scene as? UIWindowScene) else { return }
  }
}
