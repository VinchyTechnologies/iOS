//
//  SavedPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - SavedPresenter

final class SavedPresenter {

  // MARK: Lifecycle

  init(viewController: SavedViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: SavedViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = SavedViewModel

}

// MARK: SavedPresenterProtocol

extension SavedPresenter: SavedPresenterProtocol {

}
