//
//  NotesPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
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

  private func createViewModel(notes: [VNote]) -> NotesViewModel {
    var sections: [NotesViewModel.Section] = []
    var cells: [WineTableCellViewModel] = []

    for note in notes {
      if
        let wineID = note.wineID,
        let wineTitle = note.wineTitle,
        let noteText = note.noteText
      {
        cells.append(.init(imageURL: imageURL(from: wineID).toURL, titleText: wineTitle, subtitleText: noteText))
      }
    }
    sections.append(.simpleNote(cells))
    return NotesViewModel(sections: sections, navigationTitleText: localized("notes").firstLetterUppercased())
  }
}

// MARK: NotesPresenterProtocol

extension NotesPresenter: NotesPresenterProtocol {
  func showEmpty(isEmpty: Bool) {
    if isEmpty {
      viewController?.showEmptyView(title: localized("nothing_here"), subtitle: localized("you_have_not_written_any_notes_yet"))
    } else {
      viewController?.showEmptyView(title: localized("nothing_here"), subtitle: localized("no_notes_found_for_your_request"))
    }
  }

  func hideEmpty() {
    viewController?.hideEmptyView()
  }

  func update(notes: [VNote]) {
    let viewModel = createViewModel(notes: notes)
    viewController?.updateUI(viewModel: viewModel)
  }

  func showAlert() {
    viewController?.showAlert(title: localized("delete_note"), message: localized("this_action_cannot_to_be_undone"))
  }
}
