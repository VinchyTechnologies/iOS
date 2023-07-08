//
//  APIError.swift
//  Network
//
//  Created by Алексей Смирнов on 08.02.2022.
//

public enum APIError: Error {
  case invalidURL
  case decodingError
  case incorrectStatusCode(Int)
  case updateTokensErrorShouldShowAuthScreen
  case noInternetConnection
  case unknown
}
