//
//  Reviews.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

fileprivate let reviewDomain = "reviews.vinchy.tech"

private enum ReviewsEndpoint: EndpointProtocol {
  
  case all(wineID: Int64, accountID: Int64?, offset: Int, limit: Int)
  
  var host: String {
    return reviewDomain
  }
  
  var path: String {
    switch self {
    case .all:
      return "/reviews"
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
    case .all(let wineID, let accountID, let offset, let limit):
      var params: Parameters = [
        ("wine_id", wineID),
        ("offset", offset),
        ("limit", limit),
      ]
      if let accountID = accountID {
        params += [("account_id", accountID)]
      }
      return params
    }
  }
  
}

public final class Reviews {
  
  private let api = API.shared
  
  public static let shared = Reviews()
  
  private init() { }
  
  public func getReviews(
    wineID: Int64,
    accountID: Int64?,
    offset: Int,
    limit: Int,
    completion: @escaping (Result<[Review], APIError>) -> Void)
  {
    api.request(
      endpoint: ReviewsEndpoint.all(
        wineID: wineID,
        accountID: accountID,
        offset: offset,
        limit: limit),
      completion: completion)
  }
}
