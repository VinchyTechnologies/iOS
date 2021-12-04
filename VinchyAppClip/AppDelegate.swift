//
//  AppDelegate.swift
//  VinchyAppClip
//
//  Created by Алексей Смирнов on 03.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Firebase
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    FirebaseApp.configure()
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions)
    -> UISceneConfiguration
  {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

