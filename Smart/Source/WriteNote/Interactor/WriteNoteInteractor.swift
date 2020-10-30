//
//  WriteNoteInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 30.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database

final class WriteNoteInteractor {

  private let input: WriteNoteInput
  private let router: WriteNoteRouterProtocol
  private let presenter: WriteNotePresenterProtocol

  private let dataBase = Database<Note>()
  private var noteText: String?

  init(
    input: WriteNoteInput,
    router: WriteNoteRouterProtocol,
    presenter: WriteNotePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - WriteNoteInteractorProtocol

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
      try! realm(path: .notes).write { // swiftlint:disable:this force_try
        note.noteText = noteText ?? ""
      }

    case .firstTime(let wine):
      guard let noteText = noteText, !noteText.isEmpty else {
        return
      }

      let note = Note(
        id: dataBase.incrementID(path: .notes),
        wineID: wine.id,
        wineTitle: wine.title,
        wineMainImageURL: wine.mainImageUrl ?? "",
        noteText: noteText)
      
      dataBase.add(object: note, at: .notes)
    }

    router.pop()

  }

  func didChangeNoteText(_ text: String?) {
    noteText = text
  }
}
