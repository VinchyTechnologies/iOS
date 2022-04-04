//
//  DeveloperFeatureToggles.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import FirebaseRemoteConfig

let remoteConfig: RemoteConfig = {
  let remoteConfig = RemoteConfig.remoteConfig()
  let settings = RemoteConfigSettings()
  remoteConfig.configSettings = settings
  return remoteConfig
}()

let isOnboardingAvailable = true
let isDescriptionInWineDetailEnabled = false
