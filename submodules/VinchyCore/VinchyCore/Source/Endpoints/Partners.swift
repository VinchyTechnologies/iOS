//
//  Partners.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 27.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

private enum PartnersEndpoint: EndpointProtocol {
  
  case map(latitude: Double, longitude: Double, radius: Int)
  case storeInfo(partnerId: Int, affilatedId: Int)
  
  var host: String {
    return domain
  }
  
  var path: String {
    switch self {
    case .map:
      return "/partners"
      
    case .storeInfo(let partnerId, let affilatedId):
      return "/partners/" + String(partnerId) + "/stores/" + String(affilatedId)
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .map, .storeInfo:
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
    }
  }
}

public final class Partners {
  
  private let api = API.shared
  
  public static let shared = Partners()
  
  private init() { }
  
  public func getPartnersOnMap(
    latitude: Double,
    longitude: Double,
    radius: Int,
    completion: @escaping (Result<[PartnerOnMap], APIError>) -> Void)
  {
    api.request(endpoint: PartnersEndpoint.map(
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
    api.request(endpoint: PartnersEndpoint.storeInfo(
                  partnerId: partnerId,
                  affilatedId: affilatedId),
                completion: completion)
  }
}
