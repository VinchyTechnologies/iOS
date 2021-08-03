//
//  Recommendations.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 25.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - RecommendationsEndpoint

private enum RecommendationsEndpoint: EndpointProtocol {
  case personal(accountId: Int, partnerId: Int, affilatedId: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .personal(_, let partnerId, let affilatedId):
      return "/partners/" + String(partnerId) + "/stores/" + String(affilatedId) + "/recommendations"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .personal:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .personal(let accountID, _, _):
      let params: Parameters = [
        ("account_id", accountID),
      ]
      return params
    }
  }
}

// MARK: - Recommendations

public final class Recommendations {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Recommendations()

  public func getPersonalRecommendedWines(accountId: Int, partnerId: Int, affilatedId: Int, completion: @escaping (Result<[ShortWine], APIError>) -> Void) {
    api.request(
      endpoint: RecommendationsEndpoint.personal(
        accountId: accountId,
        partnerId: partnerId,
        affilatedId: affilatedId),
      completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
