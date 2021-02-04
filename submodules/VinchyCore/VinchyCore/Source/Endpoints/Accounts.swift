//
//  Accounts.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 31.01.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

fileprivate let authDomain = "auth.vinchy.tech"

private enum AccountEndpoint: EndpointProtocol {
  
  case get(email: String, password: String)
  case create(email: String, password: String)
  case activate(accountID: Int, confirmationCode: String)
  case update(accountID: Int, refreshToken: String, password: String)
  case updateTokens(accountID: Int, refreshToken: String)
  case checkConfirmationCode(accountID: Int, confirmationCode: String)
  case sendConfirmationCode(accountID: Int)
  
  var host: String {
    authDomain
  }
  
  var path: String {
    switch self {
    case .get:
      return "/accounts"
      
    case .create:
      return "/accounts"
      
    case .activate(let accountID, _):
      return "/accounts/" + String(accountID)
      
    case .update(let accountID, _, _):
      return "/accounts/" + String(accountID)
      
    case .updateTokens(let accountID, _):
      return "/accounts/" + String(accountID) + "/tokens"
      
    case .checkConfirmationCode(let accountID, _):
      return "/accounts/" + String(accountID) + "/codes"
      
    case .sendConfirmationCode(let accountID):
      return "/accounts/" + String(accountID) + "/codes"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .get:
      return .get
      
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
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case .get(let email, let password):
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
        ("confirmation_code", confirmationCode)
      ]
      
    case .update(_, let refreshToken, let password):
      return [
        ("refresh_token", refreshToken),
        ("password", password),
      ]
      
    case .updateTokens(_, let refreshToken):
      return [
        ("refresh_token", refreshToken)
      ]
      
    case .checkConfirmationCode(_, let confirmationCode):
      return [
        ("confirmation_code", confirmationCode)
      ]
      
    case .sendConfirmationCode:
      return nil
    }
  }
  
  var encoding: ParameterEncoding {
    switch self {
    case .get:
      return .httpBody
      
    case .create:
      return .httpBody
      
    case .activate:
      return .httpBody
      
    case .update:
      return .httpBody
      
    case .updateTokens:
      return .httpBody
      
    case .checkConfirmationCode:
      return .queryString
      
    case .sendConfirmationCode:
      return .httpBody
    }
  }
  
}

public final class Accounts {
  
  private let api = API.shared
  
  public static let shared = Accounts()
  
  private init() { }
  
  public func getAccount(
    email: String,
    password: String,
    completion: @escaping (Result<AccountID, APIError>) -> Void)
  {
    api.request(endpoint: AccountEndpoint.get(email: email, password: password), completion: completion)
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
    completion: @escaping (Result<[Collection], APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.activate(accountID: accountID, confirmationCode: confirmationCode),
      completion: completion)
  }
  
  public func updateAccount(
    accountID: Int,
    refreshToken: String,
    password: String,
    completion: @escaping (Result<[Collection], APIError>) -> Void)
  {
    api.request(
      endpoint: AccountEndpoint.update(accountID: accountID, refreshToken: refreshToken, password: password),
      completion: completion)
  }
  
  public func updateTokens(
    accountID: Int,
    refreshToken: String,
    completion: @escaping (Result<[Collection], APIError>) -> Void)
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
    api.request(endpoint: AccountEndpoint.checkConfirmationCode(accountID: accountID, confirmationCode: confirmationCode),
                completion: completion)
  }
  
  public func sendConfirmationCode(
    accountID: Int,
    completion: @escaping (Result<EmptyResponse, APIError>) -> Void)
  {
    api.request(endpoint: AccountEndpoint.sendConfirmationCode(accountID: accountID), completion: completion)
  }
}
