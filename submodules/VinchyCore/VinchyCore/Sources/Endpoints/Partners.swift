//
//  Partners.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 27.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//
import APINetwork

// MARK: - PartnersEndpoint

private enum PartnersEndpoint: EndpointProtocol {
  case map(latitude: Double, longitude: Double, radius: Int)
  case storeInfo(partnerId: Int, affilatedId: Int)
  case wines(partnerId: Int, affilatedId: Int, filters: [(String, String)], currencyCode: String?, limit: Int, offset: Int)
  case partnersByWine(wineID: Int64, latitude: Double, longitude: Double, limit: Int, offset: Int)
  case nearest(numberOfPartners: Int, latitude: Double, longitude: Double, radius: Int, accountID: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .map:
      return "/partners"

    case .storeInfo(let partnerId, let affilatedId):
      return "/partners/" + String(partnerId) + "/stores/" + String(affilatedId)

    case .wines(let partnerId, let affilatedId, _, _, _, _):
      return "/partners/" + String(partnerId) + "/stores/" + String(affilatedId) + "/wines"

    case .partnersByWine(let wineID, _, _, _, _):
      return "/partners/" + String(wineID)

    case .nearest(let numberOfPartners, _, _, _, _):
      return "/nearest/" + String(numberOfPartners) + "/partners/recommendations"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .map, .storeInfo, .wines, .partnersByWine, .nearest:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .map(let latitude, let longitude, let radius):
      let params: Parameters = [
        ("lat", String(latitude)),
        ("lon", String(longitude)),
        ("radius", String(radius)),
      ]
      return params

    case .storeInfo:
      return nil

    case .wines(_, _, let filters, _, let limit, let offset):
      return filters + [
        ("offset", String(offset)),
        ("limit", String(limit)),
      ]

    case .partnersByWine(_, let latitude, let longitude, let limit, let offset):
      let params: Parameters = [
        ("lat", String(latitude)),
        ("lon", String(longitude)),
        ("offset", String(offset)),
        ("limit", String(limit)),
      ]
      return params

    case .nearest(_, let latitude, let longitude, let radius, let accountID):
      let params: Parameters = [
        ("latitude", String(latitude)),
        ("longitude", String(longitude)),
        ("radius", String(radius)),
        ("account_id", String(accountID)),
      ]
      return params
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .map, .storeInfo, .partnersByWine, .nearest:
      return [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
      ]

    case .wines(_, _, _, let currencyCode, _, _):
      var dict = [
        "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
        "accept-language": Locale.current.languageCode ?? "en",
      ]
      if let currencyCode = currencyCode {
        dict["x-currency"] = currencyCode
      }
      return dict
    }
  }
}

// MARK: - Partners

public final class Partners {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Partners()

  public func getPartnersByWine(
    wineID: Int64,
    latitude: Double,
    longitude: Double,
    limit: Int,
    offset: Int,
    completion: @escaping (Result<[PartnerInfo], APIError>) -> Void)
  {
    api.request(
      endpoint: PartnersEndpoint.partnersByWine(
        wineID: wineID,
        latitude: latitude,
        longitude: longitude,
        limit: limit,
        offset: offset),
      completion: completion)
  }

  public func getPartnersOnMap(
    latitude: Double,
    longitude: Double,
    radius: Int,
    completion: @escaping (Result<[PartnerOnMap], APIError>) -> Void)
  {
    api.request(
      endpoint: PartnersEndpoint.map(
        latitude: latitude,
        longitude: longitude,
        radius: radius),
      completion: completion)
  }

  public func getPartnerStoreInfo(
    partnerId: Int,
    affilatedId: Int,
    completion: @escaping (Result<PartnerInfo, APIError>) -> Void)
  {
    api.request(
      endpoint: PartnersEndpoint.storeInfo(
        partnerId: partnerId,
        affilatedId: affilatedId),
      completion: completion)
  }

  public func getPartnerWines(partnerId: Int, affilatedId: Int, filters: [(String, String)], currencyCode: String?, limit: Int, offset: Int, completion: @escaping (Result<[ShortWine], APIError>) -> Void) {
    api.request(
      endpoint: PartnersEndpoint.wines(
        partnerId: partnerId,
        affilatedId: affilatedId,
        filters: filters,
        currencyCode: currencyCode,
        limit: limit,
        offset: offset),
      completion: completion)
  }

  public func getNearestPartners(
    numberOfPartners: Int,
    latitude: Double,
    longitude: Double,
    radius: Int,
    accountID: Int,
    completion: @escaping (Result<[NearestPartner], APIError>) -> Void)
  {
    api.request(
      endpoint: PartnersEndpoint.nearest(
        numberOfPartners: numberOfPartners,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        accountID: accountID),
      completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
