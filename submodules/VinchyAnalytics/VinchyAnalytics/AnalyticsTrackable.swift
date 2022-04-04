//
//  AnalyticsTrackable.swift
//  VinchyAnalytics
//
//  Created by Алексей Смирнов on 04.04.2022.
//

import FirebaseAnalytics

// MARK: - Tracker

public enum Tracker: CaseIterable, AnalyticsTrackable {
  case firebase

  public func trackEvent(_ event: String, params: [String: Any]?, trackers: [Tracker]) {
    trackers.forEach { tracker in
      switch tracker {
      case .firebase:
        print(event, params as Any)
        //                Analytics.logEvent(event, parameters: params)
      }
    }
  }
}

// MARK: - AnalyticsTrackable

public protocol AnalyticsTrackable {
  func trackEvent(_ event: String, params: [String: Any]?, trackers: [Tracker])
}

extension AnalyticsTrackable {
  public func trackEvent(_ event: String, params: [String: Any]? = nil, trackers: [Tracker] = Tracker.allCases) {
    trackers.forEach { tracker in
      tracker.trackEvent(event, params: params, trackers: [tracker])
    }
  }
}
