//
//  CompilationsEndpoint.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

private enum CompilationsEndpoint: EndpointProtocol {
  
  case all
  
  var host: String {
    return domain
  }
  
  var path: String {
    switch self {
    case .all:
      return "/compilations"
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
    case .all:
      return nil
    }
  }
  
}

public final class Compilations {
  
  private let api = API.shared
  
  public static let shared = Compilations()
  
  public init() { }
  
  public func getCompilations(completion: @escaping (Result<[Compilation], APIError>) -> Void) {
    api.request(endpoint: CompilationsEndpoint.all, completion: completion)
  }
  
}
