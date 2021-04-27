//
//  Partners.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 27.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

private enum PartnersEndpoint: EndpointProtocol {
  
  case map(latitude: Double, longitude: Double, radius: Int)
  
  var host: String {
    return domain
  }
  
  var path: String {
    switch self {
    case .map:
      return "/partners"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .map:
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
    completion: @escaping (Result<[PartnerOnMap], APIError>) -> Void) {
    api.request(endpoint: PartnersEndpoint.map(
                  latitude: latitude,
                  longitude: longitude,
                  radius: radius),
                completion: completion)
  }
  
}
