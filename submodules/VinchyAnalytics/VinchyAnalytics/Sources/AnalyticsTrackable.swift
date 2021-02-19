//
//  AnalyticsTrackable.swift
//  VinchyAnalytics
//
//  Created by Алексей Смирнов on 19.02.2021.
//

import Foundation

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
