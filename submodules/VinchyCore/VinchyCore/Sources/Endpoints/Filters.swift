//
//  Filters.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 13.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import APINetwork

// MARK: - FiltersEndpoint

private enum FiltersEndpoint: EndpointProtocol {
  case all(affilatedId: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .all:
      return "/filters"
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
    case .all(let affilatedId):
      return [("affiliated_id", String(affilatedId))]
    }
  }
}

// MARK: - Filters

public final class Filters {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Filters()

  public func getFilters(affilatedId: Int, completion: @escaping (Result<AvailableFilters, APIError>) -> Void) {
    api.request(endpoint: FiltersEndpoint.all(affilatedId: affilatedId), completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
