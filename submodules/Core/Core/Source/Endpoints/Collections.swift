//
//  Collections.swift
//  Core
//
//  Created by Aleksei Smirnov on 23.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

private enum CollectionEndpoint: EndpointProtocol {

    case all

    var host: String {
        return "wineappp.herokuapp.com"
    }

    var path: String {
        switch self {
        case .all:
            return "/collections"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .all:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .all:
            return nil
        }
    }

}

public final class Collections {

    let api = API.shared

    public static let shared = Collections()

    public init() { }

    public func getCollections(completion: @escaping (Result<[Core.Collection], APIError>) -> Void) {
        api.request(endpoint: CollectionEndpoint.all, completion: completion)
    }

}
