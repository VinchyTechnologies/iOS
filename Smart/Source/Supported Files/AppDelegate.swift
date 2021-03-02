//
//  AppDelegate.swift
//  Smart
//
//  Created by Aleksei Smirnov on 03.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import SwiftUI
import Sheeeeeeeeet

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

#if canImport(AdSupport)
import AdSupport
#endif

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
      launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool
  {
    
    // FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()
    
    let defaultValue = ["isAdAvailable": true as NSObject, "force_update_versions": [String]() as NSObject]
    remoteConfig.setDefaults(defaultValue)
    
    remoteConfig.fetch(withExpirationDuration: 0) { (_, error) in
      if error == nil {
        remoteConfig.activate(completion: nil)
        isAdAvailable = remoteConfig.configValue(forKey: "isAdAvailable").boolValue

        self.showForceUpdateScreen(versions: remoteConfig.configValue(forKey: "force_update_versions").jsonValue as! [String]) // swiftlint:disable:this force_cast
      }
    }
    
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
        GADMobileAds.sharedInstance().start(completionHandler: nil)
      })
    } else {
      GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "7d99d4164fe23a45e4802010db93f214" ];
    
    //        GADMobileAds.sharedInstance().start(completionHandler: nil)
    #if targetEnvironment(simulator)
    // swiftlint:disable:next force_cast
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID as! String]
    #endif
    return true
  }

  // MARK: - UISceneSession Lifecycle
  
  func application(
    _ application: UIApplication,
    configurationForConnecting
      connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions)
    -> UISceneConfiguration
  {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  private func showForceUpdateScreen(versions: [String]) {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      if versions.contains(version) {
        UIApplication.shared.asKeyWindow?.rootViewController = UIHostingController(rootView: ForceUpdateView())
      }
    }
  }
}
