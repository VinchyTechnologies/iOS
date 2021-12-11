//
//  EndpointProtocol.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

// MARK: - Scheme

public enum Scheme: String {
  case http, https
}

/// A dictionary of parameters to apply to a `URLRequest`
public typealias Parameters = [(String, Any)]

/// A dictionary of headers to apply to a `URLRequest`
public typealias HTTPHeaders = [String: String]

// MARK: - HTTPMethod

public enum HTTPMethod: String {
  case get = "GET"
  case head = "HEAD"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case connect = "CONNECT"
  case options = "OPTIONS"
  case trace = "TRACE"
  case patch = "PATCH"
}

// MARK: - EndpointProtocol

public protocol EndpointProtocol {
  var scheme: Scheme { get }
  var host: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: [(String, Any)]? { get }
  var encoding: ParameterEncoding { get }
  var headers: HTTPHeaders? { get }
  var cacheKey: String? { get }
}

// MARK: - ParameterEncoding

public enum ParameterEncoding {
  case httpBody
  case queryString
}

extension EndpointProtocol {
  public var scheme: Scheme {
    .https
  }

  public var encoding: ParameterEncoding {
    switch method {
    case .get:
      return .queryString

    default:
      return .httpBody
    }
  }

  public var headers: HTTPHeaders? {
    [
      "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
      "accept-language": Locale.current.languageCode ?? "en",
      "x-currency": UserDefaultsConfig.currency,
    ]
  }

  public var cacheKey: String? {
    nil
  }
}
