//
//  UserDefaults.swift
//  Core
//
//  Created by Aleksei Smirnov on 01.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - UserDefaultsConfig

public enum UserDefaultsConfig {
  @UserDefault("isAdult", defaultValue: false)
  public static var isAdult: Bool

  @UserDefault("agreeToTermsAndConditions", defaultValue: false)
  public static var isAgreedToTermsAndConditions: Bool

  @UserDefault("userHasSeenTutorialForReviewButton", defaultValue: false)
  public static var userHasSeenTutorialForReviewButton: Bool

  @UserDefault("lastSeenOnboardingVersion", defaultValue: 0)
  public static var lastSeenOnboardingVersion: Int

  @UserDefault("currency", defaultValue: defaultCurrency)
  public static var currency: String

  @UserDefault("accountID", defaultValue: 0)
  public static var accountID: Int

  @UserDefault("accountEmail", defaultValue: "")
  public static var accountEmail: String

  @UserDefault("userName", defaultValue: "")
  public static var userName: String

  @UserDefault("userLatitude", defaultValue: 0.0)
  public static var userLatitude: Double

  @UserDefault("userLongtitude", defaultValue: 0.0)
  public static var userLongtitude: Double

  @UserDefault("shouldUseCurrentGeo", defaultValue: true)
  public static var shouldUseCurrentGeo: Bool

  @UserDefault("appleUserId", defaultValue: "")
  public static var appleUserId: String

  @UserDefault("deviceId", defaultValue: "")
  public static var deviceId: String
}

// MARK: - UserDefault

@propertyWrapper
public struct UserDefault<T> {
  public let key: String
  public let defaultValue: T

  public init(_ key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  public var wrappedValue: T {
    get {
      UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
