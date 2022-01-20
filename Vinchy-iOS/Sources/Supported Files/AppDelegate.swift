//
//  AppDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import Firebase
import Spotlight
import SwiftUI
import UIKit

// MARK: - AppDelegate

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Internal

  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    // FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()

    let defaultValue = ["isAdAvailable": true as NSObject, "force_update_versions": [String]() as NSObject]
    remoteConfig.setDefaults(defaultValue)

    remoteConfig.fetch(withExpirationDuration: 0) { _, error in
      if error == nil {
        remoteConfig.activate(completion: nil)
        isAdAvailable = remoteConfig.configValue(forKey: "isAdAvailable").boolValue

        self.showForceUpdateScreen(versions: remoteConfig.configValue(forKey: "force_update_versions").jsonValue as! [String]) // swiftlint:disable:this force_cast
      }
    }

    //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "7d99d4164fe23a45e4802010db93f214" ];

    //        GADMobileAds.sharedInstance().start(completionHandler: nil)
    #if targetEnvironment(simulator)
    // swiftlint:disable:next force_cast
//    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID as! String]
    #endif

    if UserDefaultsConfig.deviceId == "" {
      UserDefaultsConfig.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    SpotlightService.shared.configure()

    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,

    options _: UIScene.ConnectionOptions)
    -> UISceneConfiguration
  {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: Private

  private func showForceUpdateScreen(versions: [String]) {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      if versions.contains(version) {
        UIApplication.shared.asKeyWindow?.rootViewController = UIHostingController(rootView: ForceUpdateView())
      }
    }
  }
}
