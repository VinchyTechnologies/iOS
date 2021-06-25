//
//  NotesInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import Foundation

// MARK: - NotesInteractor

final class NotesInteractor {

  // MARK: Lifecycle

  init(
    router: NotesRouterProtocol,
    presenter: NotesPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: NotesRouterProtocol
  private let presenter: NotesPresenterProtocol
  private let throttler: ThrottlerProtocol = Throttler()
  private var indexPathDelete: IndexPath?

  private var notes: [VNote] = [] {
    didSet {
      presenter.update(notes: notes)
    }
  }
}

// MARK: NotesInteractorProtocol

extension NotesInteractor: NotesInteractorProtocol {
  func didTapConfirmDeleteCell() {
    guard let indexPathDelete = indexPathDelete else {
      return
    }
    notesRepository.remove(notes[indexPathDelete.row])
    notes = notesRepository.findAll()
  }

  func didTapDeleteCell(at indexPath: IndexPath) {
    if notes[safe: indexPath.row] != nil {
      indexPathDelete = indexPath
      presenter.showAlert()
    }
  }

  func didTapNoteCell(at indexPath: IndexPath) {
    guard let note = notes[safe: indexPath.row] else { return }
    router.pushToDetailCollection(note: note)
  }

  func viewDidLoad() {
    notes = notesRepository.findAll()
  }

  func didEnterSearchText(_ searchText: String?) {
    guard
      let searchText = searchText?.firstLetterUppercased(),
      !searchText.isEmpty
    else {
      throttler.cancel()
      notes = notesRepository.findAll()
      return
    }

    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      let predicate = NSPredicate(format: "wineTitle CONTAINS %@ OR noteText CONTAINS %@", searchText, searchText)
      var searchedNotes = [VNote]()
      self?.notes.forEach { note in
        if predicate.evaluate(with: note) {
          searchedNotes.append(note)
        }
      }
      self?.notes = searchedNotes
    }
  }
}
