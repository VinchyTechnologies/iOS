//
//  OptionsRouter.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import UIKit
import VinchyCore
import VinchyUI

// MARK: - OptionsRouter

final class OptionsRouter {

  // MARK: Lifecycle

  init(
    input: OptionsInput,
    viewController: UIViewController,
    coordinator: ShowcaseRoutable & AdvancedSearchRoutable)
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

    guard let navigationController = (viewController?.navigationController as? QuestionsNavigationController) else {
      return
    }

    var allOptions: [Question.Option] = []
    navigationController.questions.forEach { question in
      allOptions += question.options
    }

    let option = allOptions.first(where: { $0.id == selectedIds.first /* check not first only ??? */ })

    navigationController.dataSource[input.question.id] = selectedIds

    if option?.shouldOpenFilter == true {
      viewController?.dismiss(animated: true, completion: {
        navigationController.questionsNavigationControllerDelegate?.didRequestShowFilters()
      })
      return
    }

    if let nextQuestion = navigationController.questions.first(where: { $0.id == option?.nextQuestionId }) {
      let controller = OptionsAssembly.assemblyModule(input: .init(question: nextQuestion, affilatedId: input.affilatedId, currencyCode: input.currencyCode), coordinator: coordinator)
      viewController?.navigationController?.pushViewController(controller, animated: true)
    } else {
      var filterIds: [Int] = []
      selectedIds.forEach { id in
        if let filterId = allOptions.first(where: { $0.id == id })?.filterId {
          filterIds.append(filterId)
        }
      }
      let params: [(String, String)] = filterIds.compactMap { id in
        ("filter_id", String(id))
      }
      pushToShowcaseViewController(input: .init(title: nil, mode: .questions(params: params, affilatedId: input.affilatedId, currencyCode: input.currencyCode)), selectedIds: selectedIds)
    }
  }
}
