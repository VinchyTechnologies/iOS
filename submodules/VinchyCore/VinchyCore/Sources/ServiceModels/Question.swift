//
//  Question.swift
//  VinchyCore
//
//  Created by Алексей Смирнов on 16.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

public struct Question: Decodable {

  // MARK: Public

  public struct Option: Decodable {
    public let id: Int
    public let text: String
    public let shouldOpenFilter: Bool
    public let nextQuestionId: Int?
    public let filterId: Int?

    private enum CodingKeys: String, CodingKey {
      case id
      case text
      case shouldOpenFilter = "should_open_filters"
      case nextQuestionId = "next_question_id"
      case filterId = "filter_id"
    }
  }

  public let id: Int
  public let text: String

  public let options: [Option]
  public let isMultipleSelectionAllowed: Bool
  public let isFirstQuestion: Bool

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case id
    case text
    case options
    case isMultipleSelectionAllowed = "is_multiple_selection_allowed"
    case isFirstQuestion = "is_first_question"
  }
}
