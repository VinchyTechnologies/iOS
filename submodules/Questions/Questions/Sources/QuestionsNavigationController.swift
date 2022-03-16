//
//  QuestionsNavigationController.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini
import UIKit
import VinchyCore
import VinchyUI

// MARK: - QuestionsNavigationControllerDelegate


// MARK: - QuestionsNavigationController

public final class QuestionsNavigationController: VinchyNavigationController {

  // MARK: Lifecycle

  public init(questions: [Question], affilatedId: Int, coordinator: OptionsAssembly.Coordinator) {
    self.questions = questions

    guard let question = questions.first(where: { $0.isFirstQuestion }) else {
      super.init(rootViewController: UIViewController())
      return
    }

    let rootViewController = OptionsAssembly.assemblyModule(input: .init(question: question, affilatedId: affilatedId), coordinator: coordinator)
    super.init(rootViewController: rootViewController)
  }

  // MARK: Public

  public weak var questionsNavigationControllerDelegate: QuestionsNavigationControllerDelegate?

  public func resetDataSource() {
    dataSource.removeAll()
  }

  // MARK: Internal

  var dataSource: [Int: [Int]] = [:]

  let questions: [Question]
}
