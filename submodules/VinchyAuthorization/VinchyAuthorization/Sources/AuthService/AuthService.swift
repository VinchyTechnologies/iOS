//
//  AuthService.swift
//  VinchyAuthorization
//
//  Created by Алексей Смирнов on 19.10.2021.
//

import AuthenticationServices
import Core
import VinchyCore

public final class AuthService {

  // MARK: Lifecycle

  private init() {
  }

  // MARK: Public

  public static let shared = AuthService()

  public func loginWithApple(
    email: String?,
    fullName: PersonNameComponents?,
    appleUserId: String,
    authorizationCode: String,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    let email = email ?? UserDefaultsConfig.accountEmail
    let userName: String
    if fullName != nil {
      userName = (fullName?.givenName ?? "") + " " + (fullName?.familyName ?? "")
    } else {
      userName = UserDefaultsConfig.userName
    }

    Accounts.shared.signInWithApple(
      email: email,
      fullName: userName,
      authCode: authorizationCode,
      deviceId: deviceId,
      appleUserId: appleUserId,
      completion: completion)
  }
}
