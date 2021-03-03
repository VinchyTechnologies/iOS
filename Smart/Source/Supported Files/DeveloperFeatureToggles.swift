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
  settings.minimumFetchInterval = 0
  remoteConfig.configSettings = settings
  return remoteConfig
}()

let isOnboardingAvailable = false
let isSmartFilterAvailable = false
let isShareUsEnabled = true
let isDescriptionInWineDetailEnabled = false
var isAdAvailable = false
let isProfileCellAvailable = true
let isMapOnVinchyVCAvailable = true
let isReviewAvailable = true
