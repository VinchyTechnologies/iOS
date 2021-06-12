//
//  AnalyticsTrackable.swift
//  Smart
//
//  Created by Алексей Смирнов on 12.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import FirebaseAnalytics

public enum Tracker: CaseIterable, AnalyticsTrackable {
  case firebase
  
  public func trackEvent(_ event: String, params: [String: Any]?, trackers: [Tracker]) {
    //        #if RELEASE
    trackers.forEach { tracker in
      switch tracker {
      case .firebase:
        print(event, params as Any)
      //                Analytics.logEvent(event, parameters: params)
      }
    }
    //        #endif
  }
}

public protocol AnalyticsTrackable {
  func trackEvent(_ event: String, params: [String: Any]?, trackers: [Tracker])
}

public extension AnalyticsTrackable {
  func trackEvent(_ event: String, params: [String: Any]? = nil, trackers: [Tracker] = Tracker.allCases) {
    trackers.forEach { tracker in
      tracker.trackEvent(event, params: params, trackers: [tracker])
    }
  }
}
