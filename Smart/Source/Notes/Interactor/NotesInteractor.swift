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
  private var searchText: String?

  private var notes: [VNote] = [] {
    didSet {
      if searchText.isNilOrEmpty {
        notes.isEmpty ? presenter.showEmpty(type: .isEmpty) : presenter.hideEmpty()
      } else {
        notes.isEmpty ? presenter.showEmpty(type: .noFound) : presenter.hideEmpty()
      }
      presenter.update(notes: notes)
    }
  }
}

// MARK: NotesInteractorProtocol

extension NotesInteractor: NotesInteractorProtocol {
  func didTapConfirmDeleteCell(wineID: Int64) {
    if let noteForDeleting = notes.first(where: { $0.wineID == wineID }) {
      notesRepository.remove(noteForDeleting)
      notes = notesRepository.findAll()
    }
  }

  func didTapDeleteCell(wineID: Int64) {
    if notes.first(where: { $0.wineID == wineID }) != nil {
      presenter.showDeletingAlert(wineID: wineID)
    }
  }

  func didTapNoteCell(wineID: Int64) {
    guard let note = notes.first(where: { $0.wineID == wineID }) else { return }
    router.pushToDetailCollection(note: note)
  }

  func viewDidLoad() {
    notes = notesRepository.findAll()
  }

  func didEnterSearchText(_ searchText: String?) {
    self.searchText = searchText

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
      notesRepository.findAll().forEach { note in
        if predicate.evaluate(with: note) {
          searchedNotes.append(note)
        }
      }
      self?.notes = searchedNotes
    }
  }
}
