//
//  Collections.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

// MARK: - CollectionEndpoint

private enum CollectionEndpoint: EndpointProtocol {
  case all
  case detail(collectionID: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .all:
      return "/collections"

    case .detail(let collectionID):
      return "/collections/" + String(collectionID)
    }
  }

  var method: HTTPMethod {
    switch self {
    case .all, .detail:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .all, .detail:
      return nil
    }
  }
}

// MARK: - Collections

public final class Collections {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Collections()

  public func getCollections(completion: @escaping (Result<[Collection], APIError>) -> Void) {
    api.request(endpoint: CollectionEndpoint.all, completion: completion)
  }

  public func getDetailCollection(collectionID: Int, completion: @escaping (Result<Collection, APIError>) -> Void) {
    api.request(endpoint: CollectionEndpoint.detail(collectionID: collectionID), completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
