//
//  WriteNotePresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import StringFormatting
import VinchyCore

// MARK: - WriteNotePresenter

final class WriteNotePresenter {

  // MARK: Lifecycle

  init(viewController: WriteNoteViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: WriteNoteViewControllerProtocol?
}

// MARK: WriteNotePresenterProtocol

extension WriteNotePresenter: WriteNotePresenterProtocol {

  var deleteTitleText: String? {
    localized("delete_note").firstLetterUppercased()
  }

  var deleteConfirmText: String? {
    localized("delete").firstLetterUppercased()
  }

  var subtitleDeleteText: String? {
    localized("this_action_cannot_to_be_undone").firstLetterUppercased()
  }

  var areYouSureToSaveTitleText: String? {
    localized("save_changes").firstLetterUppercased()
  }

  var cancelText: String? {
    localized("cancel").firstLetterUppercased()
  }

  var saveText: String? {
    localized("save").firstLetterUppercased()
  }

  func setSaveButtonActive(_ flag: Bool) {
    viewController?.setSaveButtonActive(flag)
  }

  func setPlaceholder() {
    viewController?.setupPlaceholder(
      placeholder: localized("your_thoughts_about_wine").firstLetterUppercased())
  }

  func setInitialNoteInfo(note: VNote) {
    viewController?.update(
      viewModel: .init(
        noteText: note.noteText,
        navigationText: note.wineTitle))
  }

  func setInitialNoteInfo(wine: Wine) {
    viewController?.update(viewModel: .init(noteText: nil, navigationText: wine.title))
  }
}
