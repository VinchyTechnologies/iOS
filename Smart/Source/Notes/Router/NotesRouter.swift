//
//  NotesRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - NotesRouter

final class NotesRouter {

  // MARK: Lifecycle

  init(
    input: NotesInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: NotesInteractorProtocol?

  // MARK: Private

  private let input: NotesInput

}

// MARK: NotesRouterProtocol

extension NotesRouter: NotesRouterProtocol {

}
