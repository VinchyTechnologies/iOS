//
//  SearchInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - SearchInteractor

final class SearchInteractor {

  // MARK: Lifecycle

  init(
    router: SearchRouterProtocol,
    presenter: SearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: SearchRouterProtocol
  private let presenter: SearchPresenterProtocol

}

// MARK: SearchInteractorProtocol

extension SearchInteractor: SearchInteractorProtocol {

  func viewDidLoad() {

  }
}
