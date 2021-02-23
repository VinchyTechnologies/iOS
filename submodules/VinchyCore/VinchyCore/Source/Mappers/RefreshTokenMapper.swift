//
//  RefreshTokenMapper.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 23.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
 
func mapToRefreshTokenCompletion<T: Decodable>(
  accountID: Int,
  completion: @escaping (Result<T, APIError>) -> Void,
  fun: @escaping (() -> Void)) -> ((Result<T, APIError>) -> Void)
{
  let com: ((Result<T, APIError>) -> Void) = { /*[weak self]*/ result in
    switch result {
    case .success(let model):
      completion(.success(model))
      
    case .failure(let error):
      switch error {
      case .invalidURL, .decodingError, .noData:
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
                
              case .failure(let error):
                completion(.failure(error)) // auth
              }
            }
          } else {
            completion(.failure(error)) // auth
          }
        } else {
          completion(.failure(error))
        }
      }
    }
  }
  return com
}
