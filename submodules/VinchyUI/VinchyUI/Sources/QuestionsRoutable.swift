//
//  QuestionsRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 12.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

// MARK: - QuestionsFlow

public struct QuestionsFlow {

  // MARK: Lifecycle

  public init(id: Int, questions: [Question]) {
    self.id = id
    self.questions = questions
  }

  // MARK: Public

  public struct Question {

    // MARK: Lifecycle

    public init(id: Int, questionText: String, options: [Option], isMultipleSelectionAllowed: Bool) {
      self.id = id
      self.questionText = questionText
      self.options = options
      self.isMultipleSelectionAllowed = isMultipleSelectionAllowed
    }

    // MARK: Public

    public struct Option {

      public let id: Int
      public let text: String

      public init(id: Int, text: String) {
        self.id = id
        self.text = text
      }
    }

    public let id: Int
    public let questionText: String
    public let options: [Option]
    public let isMultipleSelectionAllowed: Bool
  }

  public let id: Int
  public let questions: [Question]
}

// MARK: - QuestionsRoutable

public protocol QuestionsRoutable: AnyObject {
  func presentQuestiosViewController(affilatedId: Int, questionsFlow: QuestionsFlow)
}
