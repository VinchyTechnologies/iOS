//
//  QuestionsNavigationController.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini
import UIKit
import VinchyUI

// MARK: - QuestionsNavigationControllerDelegate

//public protocol QuestionsNavigationControllerDelegate: AnyObject {
//  func didFinishQuestionsFlow(id: Int)
//  func didClose(step: Int, flowId: Int)
//}

// MARK: - QuestionsNavigationController

public final class QuestionsNavigationController: VinchyNavigationController {

  // MARK: Lifecycle

  public init(input: QuestionsFlow, affilatedId: Int, coordinator: OptionsAssembly.Coordinator) {
    self.input = input
    super.init(rootViewController: OptionsAssembly.assemblyModule(input: .init(question: input.questions[0], number: 1, totalNumbers: input.questions.count, affilatedId: affilatedId), coordinator: coordinator))
  }

  // MARK: Public

  public func resetDataSource() {
    dataSource.removeAll()
  }

  // MARK: Internal

  var dataSource: [Int: [Int]] = [:]

  let input: QuestionsFlow
}
