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
