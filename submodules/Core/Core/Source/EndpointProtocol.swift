//
//  EndpointProtocol.swift
//  Core
//
//  Created by Aleksei Smirnov on 23.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public enum Scheme: String {
    case http, https
}

/// A dictionary of parameters to apply to a `URLRequest`
public typealias Parameters = [(String, Any)]

/// A dictionary of headers to apply to a `URLRequest`
public typealias HTTPHeaders = [String: String]

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

public protocol EndpointProtocol {

    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    var cacheKey: String? { get }
}

public enum ParameterEncoding {
    case httpBody
    case queryString
}

public extension EndpointProtocol {

    var scheme: Scheme {
        return .https
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:      return .queryString
        default:        return .httpBody
        }
    }

    var headers: HTTPHeaders? {
        return ["Authorization": getTopSecretPreferences()?.apiKey ?? "",
                "accept-language": Locale.current.languageCode ?? "en"]
    }

    var cacheKey: String? {
        return nil
    }
}
