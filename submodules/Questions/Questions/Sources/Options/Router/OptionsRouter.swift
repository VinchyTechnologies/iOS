//
//  OptionsRouter.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import UIKit
import VinchyUI

// MARK: - OptionsRouter

final class OptionsRouter {

  // MARK: Lifecycle

  init(
    input: OptionsInput,
    viewController: UIViewController,
    coordinator: ShowcaseRoutable)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: OptionsInteractorProtocol?

  // MARK: Private

  private let coordinator: OptionsAssembly.Coordinator

  private let input: OptionsInput
}

// MARK: OptionsRouterProtocol

extension OptionsRouter: OptionsRouterProtocol {

  func dismiss() {
    viewController?.dismiss(animated: true, completion: nil)
  }

  func pushToShowcaseViewController(input: ShowcaseInput, selectedIds: [Int]) {
    guard let navigationController = (viewController?.navigationController as? QuestionsNavigationController) else {
      fatalError()
    }
    navigationController.dataSource[self.input.question.id] = selectedIds
    coordinator.pushToShowcaseViewController(input: input)
  }

  func pushToNextQuestion(selectedIds: [Int]) {
    guard let navigationController = (viewController?.navigationController as? QuestionsNavigationController), let question = navigationController.input.questions[safe: input.number] else {
      return
    }

    navigationController.dataSource[input.question.id] = selectedIds

    let controller = OptionsAssembly.assemblyModule(input: .init(question: question, number: input.number + 1, totalNumbers: input.totalNumbers, affilatedId: input.affilatedId), coordinator: coordinator)
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
}
