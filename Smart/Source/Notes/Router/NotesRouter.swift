//
//  NotesRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import UIKit

// MARK: - NotesRouter

final class NotesRouter {

  // MARK: Lifecycle

  init(viewController: UIViewController)
  {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
}

// MARK: NotesRouterProtocol

extension NotesRouter: NotesRouterProtocol {}
