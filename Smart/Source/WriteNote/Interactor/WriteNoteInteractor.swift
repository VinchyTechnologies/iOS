//
//  WriteNoteInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database

// MARK: - WriteNoteInteractor

final class WriteNoteInteractor {

  // MARK: Lifecycle

  init(
    input: WriteNoteInput,
    router: WriteNoteRouterProtocol,
    presenter: WriteNotePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: WriteNoteInput
  private let router: WriteNoteRouterProtocol
  private let presenter: WriteNotePresenterProtocol
  private var noteText: String?
}

// MARK: WriteNoteInteractorProtocol

extension WriteNoteInteractor: WriteNoteInteractorProtocol {
  func viewDidLoad() {
    switch input.wine {
    case .database(let note):
      presenter.setInitialNoteInfo(note: note)

    case .firstTime(let wine):
      presenter.setInitialNoteInfo(wine: wine)
    }
  }

  func didTapSave() {
    switch input.wine {
    case .database(let note):
      notesRepository.remove(note)
      let maxId = notesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      notesRepository.append(VNote(id: id, wineID: note.wineID, wineTitle: note.wineTitle, noteText: noteText ?? ""))

    case .firstTime(let wine):
      guard let noteText = noteText, !noteText.isEmpty else {
        return
      }

      let maxId = notesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      notesRepository.append(VNote(id: id, wineID: wine.id, wineTitle: wine.title, noteText: noteText))
    }

    router.pop()
  }

  func didChangeNoteText(_ text: String?) {
    noteText = text
  }

  func didStartWriteText() {
    presenter.setPlaceholder()
  }
}
