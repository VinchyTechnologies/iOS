//
//  Wines.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Network

// MARK: - WinesEndpoint

private enum WinesEndpoint: EndpointProtocol {
//  case random(count: Int)
  case detail(wineID: Int64, currencyCode: String)
  case filter(param: [(String, String)])
  case search(title: String, offset: Int, limit: Int)
  case reviewdWines(accountId: Int, offset: Int, limit: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .detail(let wineID, _):
      return "/wines/" + String(wineID)

//    case .random:
//      return "/random_wines"

    case .filter:
      return "/wines"

    case .search:
      return "/wines"

    case .reviewdWines:
      return "/reviewed_wines"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .detail, /*.random,*/ .filter, .search, .reviewdWines:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .detail:
      return nil

//    case .random(let count):
//      return [("count", String(count))]

    case .filter(let params):
      return params

    case .search(let title, let offset, let limit):
      return [
        ("title", title),
        ("offset", String(offset)),
        ("limit", String(limit)),
      ]

    case .reviewdWines(let accountId, let offset, let limit):
      return [
        ("account_id", String(accountId)),
        ("offset", String(offset)),
        ("limit", String(limit)),
      ]
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .detail(_, let currencyCode):
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
        "x-currency": currencyCode,
      ]

    case .filter, .search, .reviewdWines:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
      ]
    }
  }
}

// MARK: - Wines

public final class Wines {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Wines()

  public func getDetailWine(wineID: Int64, currencyCode: String, completion: @escaping (Result<Wine, APIError>) -> Void) {
    api.request(endpoint: WinesEndpoint.detail(wineID: wineID, currencyCode: currencyCode), completion: completion)
  }

//  public func getRandomWines(count: Int, completion: @escaping (Result<[Wine], APIError>) -> Void) {
//    api.request(endpoint: WinesEndpoint.random(count: count), completion: completion)
//  }

  public func getFilteredWines(params: [(String, String)], completion: @escaping (Result<[ShortWine], APIError>) -> Void) {
    api.request(endpoint: WinesEndpoint.filter(param: params), completion: completion)
  }

  public func getWineBy(title: String, offset: Int, limit: Int, completion: @escaping (Result<[ShortWine], APIError>) -> Void) {
    api.request(endpoint: WinesEndpoint.search(title: title, offset: offset, limit: limit), completion: completion)
  }

  public func getReviewedWines(
    accountId: Int,
    offset: Int,
    limit: Int,
    completion: @escaping(Result<[ReviewedWine], APIError>) -> Void)
  {
    api.request(
      endpoint: WinesEndpoint.reviewdWines(
        accountId: accountId,
        offset: offset,
        limit: limit),
      completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
