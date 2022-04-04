//
//  Questions.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 16.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import Network

// MARK: - QuestionsEndpoint

private enum QuestionsEndpoint: EndpointProtocol {
  case questions(affilatedId: Int)

  // MARK: Internal

  var host: String {
    domain
  }

  var path: String {
    switch self {
    case .questions:
      return "/questions"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .questions:
      return .get
    }
  }

  var parameters: Parameters? {
    switch self {
    case .questions(let affilatedId):
      return [("affilied_id", String(affilatedId))]
    }
  }
}

// MARK: - Questions

public final class Questions {

  // MARK: Lifecycle

  private init() {}

  // MARK: Public

  public static let shared = Questions()

  public func getQuestions(affilatedId: Int, completion: @escaping (Result<[Question], APIError>) -> Void) {
    api.request(endpoint: QuestionsEndpoint.questions(affilatedId: affilatedId), completion: completion)
  }

  // MARK: Private

  private let api = API.shared
}
