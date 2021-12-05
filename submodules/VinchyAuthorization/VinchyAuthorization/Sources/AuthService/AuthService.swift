//
//  AuthService.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 19.10.2021.
//

#if !APPCLIP
import AuthenticationServices
import Core
import VinchyCore

// MARK: - User

public struct User {
  public let accountID: Int
  public let name: String
}

// MARK: - AuthService

public final class AuthService {

  // MARK: Lifecycle

  private init() {
  }

  // MARK: Public

  public static let shared = AuthService()

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

    let com: (Result<AccountInfo, APIError>) -> Void = { result in
      switch result {
      case .success(let response):
        UserDefaultsConfig.accountID = response.accountID
        UserDefaultsConfig.accountEmail = response.email
        UserDefaultsConfig.userName = response.accountName ?? ""
        UserDefaultsConfig.appleUserId = appleUserId
        Keychain.shared.accessToken = response.accessToken
        Keychain.shared.refreshToken = response.refreshToken
        completion(.success(response))

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
  }
}
#endif
