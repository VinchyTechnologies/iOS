//
//  Reviews.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

private let reviewDomain = "reviews.vinchy.tech"

// MARK: - ReviewsEndpoint

private enum ReviewsEndpoint: EndpointProtocol {
  case all(wineID: Int64, accountID: Int?, offset: Int, limit: Int)
  case create(wineID: Int64, accountID: Int, rating: Double, comment: String?)
  case update(reviewID: Int, rating: Double, comment: String?)
  case rating(wineID: Int64)

  // MARK: Internal

  var host: String {
    reviewDomain
  }

  var path: String {
    switch self {
    case .all, .create:
      return "/reviews"

    case .update(let reviewID, _, _):
      return "/reviews/" + String(reviewID)

    case .rating:
      return "/rating"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .all:
      return .get

    case .create:
      return .post

    case .update:
      return .put

    case .rating:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .all(let wineID, let accountID, let offset, let limit):
      var params: Parameters = [
        ("wine_id", String(wineID)),
        ("offset", String(offset)),
        ("limit", String(limit)),
      ]
      if let accountID = accountID {
        params += [("account_id", String(accountID))]
      }
      return params

    case .create(let wineID, let accountID, let rating, let comment):
      let params: Parameters = [
        ("wine_id", wineID),
        ("account_id", accountID),
        ("rating", rating),
        ("comment", comment as Any),
      ]
      return params

    case .update(_, let rating, let comment):
      return [
        ("rating", rating),
        ("comment", comment as Any),
      ]

    case .rating(let wineID):
      return [("wine_id", String(wineID))]
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .all, .rating:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
        "x-currency": Locale.current.currencyCode ?? "USD",
      ]

    case .create, .update:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
        "x-currency": Locale.current.currencyCode ?? "USD",
        "x-jwt-token": Keychain.shared.accessToken ?? "",
      ]
    }
  }
}

// MARK: - Reviews

public final class Reviews {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Reviews()

  public func getReviews(
    wineID: Int64,
    accountID: Int?,
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

  public func createReview(
    wineID: Int64,
    accountID: Int,
    rating: Double,
    comment: String?,
    completion: @escaping (Result<Review, APIError>) -> Void)
  {
//    let refreshTokenCompletion = mapToRefreshTokenCompletion(accountID: accountID, completion: completion) { [weak self] in
//      self?.createReview(wineID: wineID, accountID: accountID, rating: rating, comment: comment, completion: completion)
//    }

    api.request(
      endpoint: ReviewsEndpoint.create(
        wineID: wineID,
        accountID: accountID,
        rating: rating,
        comment: comment),
      completion: completion)
  }

  public func updateReview(
    reviewID: Int,
    rating: Double,
    comment: String?,
    completion: @escaping (Result<Review, APIError>) -> Void)
  {
//    let accountID = UserDefaultsConfig.accountID
//    let refreshTokenCompletion = mapToRefreshTokenCompletion(accountID: accountID, completion: completion) { [weak self] in
//      self?.updateReview(reviewID: reviewID, rating: rating, comment: comment, completion: completion)
//    }

    api.request(
      endpoint: ReviewsEndpoint.update(reviewID: reviewID, rating: rating, comment: comment),
      completion: completion)
  }

  public func getRating(
    wineID: Int64,
    completion: @escaping (Result<Rating, APIError>) -> Void)
  {
    api.request(endpoint: ReviewsEndpoint.rating(wineID: wineID), completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
