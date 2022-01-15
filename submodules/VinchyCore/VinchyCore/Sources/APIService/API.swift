//
//  API.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public let domain = "vinchy.tech" // "wineappp.herokuapp.com"

// MARK: - APIError

public enum APIError: Error {
  case invalidURL
  case decodingError
  case incorrectStatusCode(Int)
  case updateTokensErrorShouldShowAuthScreen
  case noInternetConnection
  case unknown
}

// MARK: - API

final class API {

  // MARK: Lifecycle

  private init() {}

  // MARK: Internal

  static let shared = API()

  func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, APIError>) -> Void) {
    var urlComponents = URLComponents()
    urlComponents.scheme = endpoint.scheme.rawValue
    urlComponents.host = endpoint.host
    urlComponents.path = endpoint.path

    if endpoint.encoding == .queryString, endpoint.parameters != nil {
      var queryItems = [URLQueryItem]()
      endpoint.parameters?.forEach { key, value in
        if let stringValue = value as? String {
          queryItems.append(URLQueryItem(name: key, value: stringValue))
        }
      }
      urlComponents.queryItems = queryItems
    }

    guard let url = urlComponents.url else {
      DispatchQueue.main.async {
        completion(.failure(.invalidURL))
      }
      return
    }

    var request = URLRequest(url: url)

    if endpoint.encoding == .httpBody, endpoint.parameters != nil {
      let dictionary = endpoint.parameters?.reduce(into: [:]) { $0[$1.0] = $1.1 }
      let jsonData = try? JSONSerialization.data(withJSONObject: dictionary as Any)
      request.httpBody = jsonData
    }

    if endpoint.headers != nil {
      endpoint.headers?.forEach { key, value in
        request.setValue(value, forHTTPHeaderField: key)
      }
    }

    request.httpMethod = endpoint.method.rawValue

    #if DEBUG
    print(request)
    #endif

    URLSession.shared.dataTask(with: request) { data, response, error in

      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
        DispatchQueue.main.async {
          if let error = error as? URLError {
            switch error.errorCode {
            case NSURLErrorNotConnectedToInternet:
              completion(.failure(.noInternetConnection))

            default:
              completion(.failure(.unknown))
            }
          } else {
            completion(.failure(.unknown))
          }
        }
        return
      }

      guard (200 ... 299) ~= response.statusCode else {
        DispatchQueue.main.async {
          completion(.failure(.incorrectStatusCode(response.statusCode)))
        }
        return
      }

      do {
//        print("===", T.self, String(data: data, encoding: .utf8) as Any)
        if T.self == EmptyResponse.self && data.isEmpty {
          DispatchQueue.main.async {
            completion(.success(EmptyResponse() as! T)) // swiftlint:disable:this force_cast
          }
        } else {
          let obj = try JSONDecoder().decode(T.self, from: data)
          DispatchQueue.main.async {
            completion(.success(obj))
          }
        }
      } catch {
        DispatchQueue.main.async {
//          print("===", T.self, String(data: data, encoding: .utf8) as Any)
          completion(.failure(.decodingError))
        }
      }
    }.resume()
  }
}

extension Dictionary {
  func percentEncoded() -> Data? {
    map { key, value in
      let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      return escapedKey + "=" + escapedValue
    }
    .joined(separator: "&")
    .data(using: .utf8)
  }
}

extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="

    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    return allowed
  }()
}
