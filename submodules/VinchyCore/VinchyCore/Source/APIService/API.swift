//
//  API.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

let domain = "vinchy.tech" //"wineappp.herokuapp.com"

public enum APIError: Error {

    case invalidURL
    case decodingError
    case incorrectStatusCode(Int)
    case noData
}

final class API {

    static let shared = API()

    init() { }

    func request<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, APIError>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        if endpoint.method == .get && endpoint.parameters != nil {
            var queryItems = [URLQueryItem]()
            endpoint.parameters?.forEach({ (key, value) in
                if let stringValue = value as? String {
                    queryItems.append(URLQueryItem(name: key, value: stringValue))
                }
            })
            urlComponents.queryItems = queryItems
        } else {
            // TODO: - http body
        }

        guard let url = urlComponents.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }

        var request = URLRequest(url: url)

        if endpoint.headers != nil {
            endpoint.headers?.forEach({ (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            })
        }

        request.httpMethod = endpoint.method.rawValue

        print(request)

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
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
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(obj))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}

extension Dictionary {

    func percentEncoded() -> Data? {
        return map { key, value in
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
