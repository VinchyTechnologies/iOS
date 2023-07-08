//
//  AuthService.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 05.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import APINetwork
import AuthenticationServices
import Combine
import Core

// MARK: - User

public struct User {
  public let accountID: Int
  public let name: String
}

// MARK: - AuthEvent

public enum AuthEvent {
  case loggedIn, logout
}

// MARK: - AuthService

public final class AuthService {

  // MARK: Lifecycle

  private init() {
  }

  // MARK: Public

  public static let shared = AuthService()

  public let eventProducer = PassthroughSubject<AuthEvent, Never>()

  public var isAuthorized: Bool {
    UserDefaultsConfig.accountID != 0
  }

  public var currentUser: User? {
    if isAuthorized {
      return .init(
        accountID: UserDefaultsConfig.accountID,
        name: UserDefaultsConfig.userName)
    } else {
      return nil
    }
  }

  public func loginWithApple(
    email: String?,
    fullName: PersonNameComponents?,
    appleUserId: String,
    authorizationCode: String,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    let deviceId = UserDefaultsConfig.deviceId

    if let email = email {
      UserDefaultsConfig.accountEmail = email
    }

    if let fullName = fullName {
      UserDefaultsConfig.userName = (fullName.givenName ?? "") + " " + (fullName.familyName ?? "")
    }

    let com: (Result<AccountInfo, APIError>) -> Void = { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        UserDefaultsConfig.accountID = response.accountID
        UserDefaultsConfig.accountEmail = response.email
        UserDefaultsConfig.userName = response.accountName ?? ""
        UserDefaultsConfig.appleUserId = appleUserId
        Keychain.shared.accessToken = response.accessToken
        Keychain.shared.refreshToken = response.refreshToken
        completion(.success(response))
        self.eventProducer.send(.loggedIn)

      case .failure(let error):
        completion(.failure(error))
      }
    }

    Accounts.shared.signInWithApple(
      email: UserDefaultsConfig.accountEmail,
      fullName: UserDefaultsConfig.userName,
      authCode: authorizationCode,
      deviceId: deviceId,
      appleUserId: appleUserId,
      completion: com)
  }

  public func logout() {
    UserDefaultsConfig.accountEmail = ""
    UserDefaultsConfig.accountID = 0
    UserDefaultsConfig.userName = ""
    UserDefaultsConfig.appleUserId = ""
    Keychain.shared.accessToken = nil
    Keychain.shared.refreshToken = nil
    Keychain.shared.password = nil
    eventProducer.send(.logout)
  }
}
