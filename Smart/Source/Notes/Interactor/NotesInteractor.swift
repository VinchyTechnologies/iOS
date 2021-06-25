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

  private var notes: [VNote] = []
}

// MARK: NotesInteractorProtocol

extension NotesInteractor: NotesInteractorProtocol {

  func viewDidLoad() {
    notes = notesRepository.findAll()
    presenter.update(notes: notes)
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
