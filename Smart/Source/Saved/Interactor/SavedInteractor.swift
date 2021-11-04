//
//  SavedInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - SavedInteractor

final class SavedInteractor {

  // MARK: Lifecycle

  init(
    router: SavedRouterProtocol,
    presenter: SavedPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: SavedRouterProtocol
  private let presenter: SavedPresenterProtocol

}

// MARK: SavedInteractorProtocol

extension SavedInteractor: SavedInteractorProtocol {

  func viewDidLoad() {

  }
}
