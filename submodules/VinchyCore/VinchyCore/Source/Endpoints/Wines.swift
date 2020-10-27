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
    case search(title: String, offset: Int, limit: Int)

    var host: String {
        return domain
    }

    var path: String {
        switch self {
        case .detail(let wineID):
            return "/wines/" + String(wineID)

        case .random:
            return "/random_wines"

        case .filter:
            return "/wines"
            
        case .search:
            return "/wines"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .detail, .random, .filter, .search:
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

        case .search(let title, let offset, let limit):
            return [
                ("title", title),
                ("offset", String(offset)),
                ("limit", String(limit))
            ]
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

    public func getWineBy(title: String, offset: Int, limit: Int, completion: @escaping (Result<[Wine], APIError>) -> Void) {
        api.request(endpoint: WinesEndpoint.search(title: title, offset: offset, limit: limit), completion: completion)
    }
}
