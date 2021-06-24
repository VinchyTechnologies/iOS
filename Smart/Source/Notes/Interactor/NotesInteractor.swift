//
//  NotesInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

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

}

// MARK: NotesInteractorProtocol

extension NotesInteractor: NotesInteractorProtocol {

  func viewDidLoad() {

  }
}
