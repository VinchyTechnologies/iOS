//
//  EndpointProtocol.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Network

// MARK: - Scheme

public let domain = "vinchy.tech" // "wineappp.herokuapp.com"

extension EndpointProtocol {
  public var scheme: Scheme {
    .https
  }

  public var encoding: ParameterEncoding {
    switch method {
    case .get:
      return .queryString

    default:
      return .httpBody
    }
  }

  public var headers: HTTPHeaders? {
    [
      "Authorization": "VFAXGm53nG7zBtEuF5DVAhK9YKuHBJ9xTjuCeFyHDxbP4s6gj6",
      "accept-language": Locale.current.languageCode ?? "en",
    ]
  }

  public var cacheKey: String? {
    nil
  }
}
