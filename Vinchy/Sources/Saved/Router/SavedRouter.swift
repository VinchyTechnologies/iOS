//
//  SavedRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - SavedRouter

final class SavedRouter {

  // MARK: Lifecycle

  init(
    input: SavedInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: SavedInteractorProtocol?

  // MARK: Private

  private let input: SavedInput

}

// MARK: SavedRouterProtocol

extension SavedRouter: SavedRouterProtocol {

}
