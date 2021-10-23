//
//  Accounts.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 31.01.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

private let authDomain = "auth.vinchy.tech"

// MARK: - AccountEndpoint

private enum AccountEndpoint: EndpointProtocol {
  case auth(email: String, password: String)
  case create(email: String, password: String)
  case activate(accountID: Int, confirmationCode: String)
  case update(accountID: Int, accountName: String?)
  case updateTokens(accountID: Int, refreshToken: String)
  case checkConfirmationCode(accountID: Int, confirmationCode: String)
  case sendConfirmationCode(accountID: Int)
  case signInWithApple(email: String, fullName: String, authCode: String, deviceId: String, appleUserId: String)

  // MARK: Internal

  var host: String {
    authDomain
  }

  var path: String {
    switch self {
    case .auth:
      return "/accounts/auth"

    case .create:
      return "/accounts"

    case .activate(let accountID, _):
      return "/accounts/" + String(accountID)

    case .update(let accountID, _):
      return "/accounts/" + String(accountID)

    case .updateTokens(let accountID, _):
      return "/accounts/" + String(accountID) + "/tokens"

    case .checkConfirmationCode(let accountID, _):
      return "/accounts/" + String(accountID) + "/codes"

    case .sendConfirmationCode(let accountID):
      return "/accounts/" + String(accountID) + "/codes"

    case .signInWithApple:
      return "/sign_in_with_apple"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .auth:
      return .post

    case .create:
      return .post

    case .activate:
      return .post

    case .update:
      return .patch

    case .updateTokens:
      return .put

    case .checkConfirmationCode:
      return .get

    case .sendConfirmationCode:
      return .post

    case .signInWithApple:
      return .post
    }
  }

  var parameters: Parameters? {
    switch self {
    case .auth(let email, let password):
      return [
        ("email", email),
        ("password", password),
      ]

    case .create(let email, let password):
      return [
        ("email", email),
        ("password", password),
      ]

    case .activate(_, let confirmationCode):
      return [
        ("confirmation_code", confirmationCode),
      ]

    case .update(_, let accountName):
      return [
        ("account_name", accountName ?? ""),
      ]

    case .updateTokens(_, let refreshToken):
      return [
        ("refresh_token", refreshToken),
      ]

    case .checkConfirmationCode(_, let confirmationCode):
      return [
        ("confirmation_code", confirmationCode),
      ]

    case .sendConfirmationCode:
      return nil

    case .signInWithApple(let email, let fullName, let authCode, let deviceId, let appleUserId):
      return [
        ("email", email),
        ("account_name", fullName),
        ("device_id", deviceId),
        ("apple_user_id", appleUserId),
        ("code", authCode),
      ]
    }
  }

  var encoding: ParameterEncoding {
    switch self {
    case .auth:
      return .httpBody

    case .create:
      return .httpBody

    case .activate:
      return .httpBody

    case .update:
      return .queryString

    case .updateTokens:
      return .httpBody

    case .checkConfirmationCode:
      return .queryString

    case .sendConfirmationCode:
      return .httpBody

    case .signInWithApple:
      return .queryString
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .auth, .create, .updateTokens, .signInWithApple, .activate, .checkConfirmationCode, .sendConfirmationCode:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
        "x-currency": Locale.current.currencyCode ?? "USD",
      ]

    case .update:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
        "x-currency": Locale.current.currencyCode ?? "USD",
        "x-jwt-token": Keychain.shared.accessToken ?? "",
      ]
    }
  }
}

// MARK: - Accounts

public final class Accounts {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Accounts()

  public func auth(
    email: String,
    password: String,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    api.request(endpoint: AccountEndpoint.auth(email: email, password: password), completion: completion)
  }

  public func createNewAccount(
    email: String,
    password: String,
    completion: @escaping (Result<AccountID, APIError>) -> Void)
  {
    api.request(endpoint: AccountEndpoint.create(email: email, password: password), completion: completion)
  }

  public func activateAccount(
    accountID: Int,
    confirmationCode: String,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.activate(accountID: accountID, confirmationCode: confirmationCode),
      completion: completion)
  }

  public func updateAccount(
    accountID: Int,
    accountName: String?,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    let refreshTokenCompletion = mapToRefreshTokenCompletion(accountID: accountID, completion: completion) { [weak self] in
      self?.updateAccount(accountID: accountID, accountName: accountName, completion: completion)
    }

    api.request(
      endpoint: AccountEndpoint.update(accountID: accountID, accountName: accountName),
      completion: refreshTokenCompletion)
  }

  public func updateTokens(
    accountID: Int,
    refreshToken: String,
    completion: @escaping (Result<UpdateTokensResponse, APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.updateTokens(accountID: accountID, refreshToken: refreshToken),
      completion: completion)
  }

  public func checkConfirmationCode(
    accountID: Int,
    confirmationCode: String,
    completion: @escaping (Result<[Collection], APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.checkConfirmationCode(
        accountID: accountID,
        confirmationCode: confirmationCode),
      completion: completion)
  }

  public func sendConfirmationCode(
    accountID: Int,
    completion: @escaping (Result<EmptyResponse, APIError>) -> Void)
  {
    api.request(endpoint: AccountEndpoint.sendConfirmationCode(accountID: accountID), completion: completion)
  }

  public func signInWithApple(
    email: String,
    fullName: String,
    authCode: String,
    deviceId: String,
    appleUserId: String,
    completion: @escaping (Result<AccountInfo, APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.signInWithApple(
        email: email,
        fullName: fullName,
        authCode: authCode,
        deviceId: deviceId,
        appleUserId: appleUserId),
      completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
