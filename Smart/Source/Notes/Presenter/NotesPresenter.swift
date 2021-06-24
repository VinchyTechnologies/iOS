//
//  NotesPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

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

}

// MARK: NotesPresenterProtocol

extension NotesPresenter: NotesPresenterProtocol {

}
