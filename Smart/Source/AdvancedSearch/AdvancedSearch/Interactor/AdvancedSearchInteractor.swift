//
//  AdvancedSearchInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class AdvancedSearchInteractor {

  private let router: AdvancedSearchRouterProtocol
  private let presenter: AdvancedSearchPresenterProtocol

  init(
    router: AdvancedSearchRouterProtocol,
    presenter: AdvancedSearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }
}

// MARK: - AdvancedSearchInteractorProtocol

extension AdvancedSearchInteractor: AdvancedSearchInteractorProtocol {

  func viewDidLoad() {

  }
}
