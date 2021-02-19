//
//  Tracker.swift
//  VinchyAnalytics
//
//  Created by Алексей Смирнов on 19.02.2021.
//

import FirebaseAnalytics

public enum Tracker: CaseIterable, AnalyticsTrackable {
  case firebase
  
  public func trackEvent(_ event: String, params: [String: Any]?, trackers: [Tracker]) {
    //        #if RELEASE
    trackers.forEach { tracker in
      switch tracker {
      case .firebase:
        print(event, params)
      //                Analytics.logEvent(event, parameters: params)
      }
    }
    //        #endif
  }
}
