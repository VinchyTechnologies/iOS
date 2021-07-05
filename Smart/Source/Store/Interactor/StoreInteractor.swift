//
//  StoreInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - StoreInteractor

final class StoreInteractor {

  // MARK: Lifecycle

  init(
    router: StoreRouterProtocol,
    presenter: StorePresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: StoreRouterProtocol
  private let presenter: StorePresenterProtocol

}

// MARK: StoreInteractorProtocol

extension StoreInteractor: StoreInteractorProtocol {

  func viewDidLoad() {

  }
}
