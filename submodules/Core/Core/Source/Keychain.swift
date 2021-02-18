//
//  Keychain.swift
//  Core
//
//  Created by Алексей Смирнов on 04.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import KeychainAccess

fileprivate enum C {
  static let keychainServiceName = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping
  static let accessToken = keychainServiceName + ".accessToken"
  static let refreshToken = keychainServiceName + ".refreshToken"
}

public final class Keychain {
  
  private let keychainService = KeychainAccess.Keychain(service: C.keychainServiceName)
  
  private init() { }
  
  public static let shared = Keychain()
  
  public var accessToken: String? {
    get {
      keychainService[C.accessToken]
    }
    set {
      keychainService[C.accessToken] = newValue
    }
  }
  
  public var refreshToken: String? {
    get {
      keychainService[C.refreshToken]
    }
    set {
      keychainService[C.refreshToken] = newValue
    }
  }
}
