//
//  StoresInteractor.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - StoresInteractor

final class StoresInteractor {

  // MARK: Lifecycle

  init(
    router: StoresRouterProtocol,
    presenter: StoresPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: StoresRouterProtocol
  private let presenter: StoresPresenterProtocol
}

// MARK: StoresInteractorProtocol

extension StoresInteractor: StoresInteractorProtocol {
  func viewDidLoad() {}
}
