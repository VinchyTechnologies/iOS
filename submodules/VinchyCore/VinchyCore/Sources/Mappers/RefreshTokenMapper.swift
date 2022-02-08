//
//  RefreshTokenMapper.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 23.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Network

func mapToRefreshTokenCompletion<T: Decodable>(
  accountID: Int,
  completion: @escaping (Result<T, APIError>) -> Void,
  fun: @escaping (() -> Void)) -> ((Result<T, APIError>) -> Void)
{

  func logout() {
    UserDefaultsConfig.accountEmail = ""
    UserDefaultsConfig.accountID = 0
    UserDefaultsConfig.userName = ""
    UserDefaultsConfig.appleUserId = ""
    Keychain.shared.accessToken = nil
    Keychain.shared.refreshToken = nil
    Keychain.shared.password = nil
  }

  let com: ((Result<T, APIError>) -> Void) = { result in
    switch result {
    case .success(let model):
      completion(.success(model))

    case .failure(let error):
      switch error {
      case .invalidURL, .decodingError, .unknown, .noInternetConnection:
        completion(.failure(error))

      case .incorrectStatusCode(let code):
        if code == 401 {
          if let refreshToken = Keychain.shared.refreshToken {
            Accounts.shared.updateTokens(accountID: accountID, refreshToken: refreshToken) { result in
              switch result {
              case .success(let model):
                Keychain.shared.accessToken = model.accessToken
                Keychain.shared.refreshToken = model.refreshToken
                fun()

              case .failure:
                logout()
                completion(.failure(.updateTokensErrorShouldShowAuthScreen)) // auth
              }
            }
          } else {
            logout()
            completion(.failure(.updateTokensErrorShouldShowAuthScreen)) // auth
          }
        } else {
          completion(.failure(error))
        }

      case .updateTokensErrorShouldShowAuthScreen:
        logout()
        completion(.failure(.updateTokensErrorShouldShowAuthScreen))
      }
    }
  }
  return com
}
