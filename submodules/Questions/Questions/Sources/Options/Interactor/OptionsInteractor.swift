//
//  OptionsInteractor.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import Foundation

// MARK: - OptionsInteractor

final class OptionsInteractor {

  // MARK: Lifecycle

  init(
    input: OptionsInput,
    router: OptionsRouterProtocol,
    presenter: OptionsPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private var selectedIds: [Int] = []

  private let input: OptionsInput
  private let router: OptionsRouterProtocol
  private let presenter: OptionsPresenterProtocol
}

// MARK: OptionsInteractorProtocol

extension OptionsInteractor: OptionsInteractorProtocol {

  func didTapClose() {
    router.dismiss()
  }

  func didTapNextButton() {
    // save to navigation Controller ???
//    if input.number == input.totalNumbers {
//      router.pushToShowcaseViewController(input: .init(title: nil, mode: .questions(optionsIds: selectedIds, affilatedId: input.affilatedId)), selectedIds: selectedIds)
//    } else {
    router.pushToNextQuestion(selectedIds: selectedIds)
//    }
  }

  func didSelectOption(id: Int) {
    if selectedIds.contains(id) {
      selectedIds.removeAll(where: { $0 == id })
    } else {
      if !input.question.isMultipleSelectionAllowed {
        selectedIds.removeAll()
      }
      selectedIds.append(id)
    }
    presenter.update(selectedIds: selectedIds)
  }

  func viewDidLoad() {
//    presenter.update(selectedIds: selectedIds)
  }

  func viewWillAppear(dataSource: [Int: [Int]]) {
    selectedIds = dataSource[input.question.id] ?? []
    presenter.update(selectedIds: selectedIds)
  }
}
