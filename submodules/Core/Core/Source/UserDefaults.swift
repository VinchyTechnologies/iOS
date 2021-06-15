//
//  UserDefaults.swift
//  Core
//
//  Created by Aleksei Smirnov on 01.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct UserDefaultsConfig {

  @UserDefault("isAdult", defaultValue: false)
  static public var isAdult: Bool

  @UserDefault("agreeToTermsAndConditions", defaultValue: false)
  static public var isAgreedToTermsAndConditions: Bool

  @UserDefault("lastSeenOnboardingVersion", defaultValue: 0)
  static public var lastSeenOnboardingVersion: Int
  
  @UserDefault("currency", defaultValue: Locale.current.currencyCode ?? "USD")
  static public var currency: String

  @UserDefault("accountID", defaultValue: 0)
  static public var accountID: Int
  
  @UserDefault("accountEmail", defaultValue: "")
  static public var accountEmail: String
  
  @UserDefault("userName", defaultValue: "")
  static public var userName: String
}

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
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
