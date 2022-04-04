//
//  QuestionsRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 12.03.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

// MARK: - QuestionsNavigationControllerDelegate

//public struct QuestionsFlow {
//
//  // MARK: Lifecycle
//
//  public init(questions: [Question]) {
//    self.questions = questions
//  }
//
//  // MARK: Public
//
//  public struct Question {
//
//    // MARK: Lifecycle
//
//    public init(id: Int, questionText: String, options: [Option], isMultipleSelectionAllowed: Bool, isFirstQuestion: Bool) {
//      self.id = id
//      self.questionText = questionText
//      self.options = options
//      self.isMultipleSelectionAllowed = isMultipleSelectionAllowed
//      self.isFirstQuestion = isFirstQuestion
//    }
//
//    // MARK: Public
//
//    public struct Option {
//
//      public let id: Int
//      public let text: String
//      public let shouldOpenFilters: Bool
//      public let nextQuestionId: Int?
//
//      public init(id: Int, text: String, shouldOpenFilters: Bool, nextQuestionId: Int?) {
//        self.id = id
//        self.text = text
//        self.shouldOpenFilters = shouldOpenFilters
//        self.nextQuestionId = nextQuestionId
//      }
//    }
//
//    public let id: Int
//    public let questionText: String
//    public let options: [Option]
//    public let isMultipleSelectionAllowed: Bool
//    public let isFirstQuestion: Bool
//  }
//
//  public let questions: [Question]
//}

public protocol QuestionsNavigationControllerDelegate: AnyObject {
  func didRequestShowFilters()
}

// MARK: - QuestionsRoutable

public protocol QuestionsRoutable: AnyObject {
  func presentQuestiosViewController(affilatedId: Int, questions: [Question], currencyCode: String, questionsNavigationControllerDelegate: QuestionsNavigationControllerDelegate?)
}
