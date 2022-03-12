//
//  OptionsPresenter.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini

// MARK: - OptionsPresenter

final class OptionsPresenter {

  // MARK: Lifecycle

  init(input: OptionsInput, viewController: OptionsViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: OptionsViewControllerProtocol?

  // MARK: Private

  private let input: OptionsInput
}

// MARK: OptionsPresenterProtocol

extension OptionsPresenter: OptionsPresenterProtocol {
  func update(selectedIds: [Int]) {
    let navigationTitle = String(input.number) + "/" + String(input.totalNumbers)
    let items: [OptionsViewModel.Item] = input.question.options.compactMap { option in
      .common(content: .init(id: option.id, titleText: option.text, isSelected: selectedIds.contains(option.id)))
    }
    let subtitleText = input.question.isMultipleSelectionAllowed ? "Можно выбрать несколько вариантов" : "Можно выбрать только один вариант"
    let bottomBarViewModel: BottomPriceBarView.Content? = {
      let text = input.number == input.totalNumbers ? "Завершить" : "Далее"

      if selectedIds.isEmpty {
        return .init(leadingText: nil, trailingButtonText: text)
      } else {
        return .init(leadingText: nil, trailingButtonText: text)
      }
    }()

    viewController?.updateUI(viewModel: .init(navigationTitle: navigationTitle, header: .init(titleText: input.question.questionText, subtitleText: subtitleText), items: items, bottomBarViewModel: bottomBarViewModel, isNextButtonEnabled: !selectedIds.isEmpty))
  }
}
