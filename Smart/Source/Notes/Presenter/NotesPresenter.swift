//
//  NotesPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation
import StringFormatting

// MARK: - NotesPresenter

final class NotesPresenter {

  // MARK: Lifecycle

  init(viewController: NotesViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: NotesViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = NotesViewModel

  private func createViewModel() -> NotesViewModel {
    var sections: [NotesViewModel.Section] = []
    //заполнить секции
    return NotesViewModel(sections: sections, navigationTitleText: localized("notes").firstLetterUppercased())
  }

}

// MARK: NotesPresenterProtocol

extension NotesPresenter: NotesPresenterProtocol {
  func update() {
    let viewModel = createViewModel()
    viewController?.updateUI(viewModel: viewModel)
  }
}
