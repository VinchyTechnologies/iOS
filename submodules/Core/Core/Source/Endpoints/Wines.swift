//
//  Wines.swift
//  Core
//
//  Created by Aleksei Smirnov on 27.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

private enum WinesEndpoint: EndpointProtocol {

    case random(count: Int)
    case filter(param: [(String, String)])

    var host: String {
        return "wineappp.herokuapp.com"
    }

    var path: String {
        switch self {
        case .random:
            return "/random_wines"
        case .filter:
            return "/wines"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .random, .filter:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .random(let count):
            return [("count", String(count))]
        case .filter(let params):
            return params
        }
    }

}

public final class Wines {

    let api = API.shared

    public static let shared = Wines()

    public init() { }

    public func getRandomWines(count: Int, completion: @escaping (Result<[Core.Wine], APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.random(count: count), completion: completion)
    }

    public func getFilteredWines(params: [(String, String)], completion: @escaping (Result<[Core.Wine], APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.filter(param: params), completion: completion)
    }

}
