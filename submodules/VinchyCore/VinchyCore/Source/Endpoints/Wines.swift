//
//  Wines.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

private enum WinesEndpoint: EndpointProtocol {

    case random(count: Int)
    case detail(wineID: Int64)
    case filter(param: [(String, String)])

    var host: String {
        return "wineappp.herokuapp.com"
    }

    var path: String {
        switch self {
        case .detail(let wineID):
            return "/wines/" + String(wineID)
        case .random:
            return "/random_wines"
        case .filter:
            return "/wines"

        }
    }

    var method: HTTPMethod {
        switch self {
        case .detail, .random, .filter:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .detail:
            return nil
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

    public func getDetailWine(wineID: Int64, completion: @escaping (Result<Wine, APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.detail(wineID: wineID), completion: completion)
    }

    public func getRandomWines(count: Int, completion: @escaping (Result<[Wine], APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.random(count: count), completion: completion)
    }

    public func getFilteredWines(params: [(String, String)], completion: @escaping (Result<[Wine], APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.filter(param: params), completion: completion)
    }

}
