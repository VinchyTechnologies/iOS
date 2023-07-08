//
//  CompilationsEndpoint.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//
import APINetwork

// MARK: - CompilationsEndpoint

private enum CompilationsEndpoint: EndpointProtocol {
  case all

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .all:
      return "/v2/compilations"
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

// MARK: - Compilations

public final class Compilations {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Compilations()

  public func getCompilations(completion: @escaping (Result<[Compilation], APIError>) -> Void) {
    api.request(endpoint: CompilationsEndpoint.all, completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
