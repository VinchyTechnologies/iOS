//
//  AdvancedSearchInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core

final class AdvancedSearchInteractor {

  private let router: AdvancedSearchRouterProtocol
  private let presenter: AdvancedSearchPresenterProtocol
  private let filters: [Filter]
  private var selectedFilters: [FilterItem] = []

  init(
    router: AdvancedSearchRouterProtocol,
    presenter: AdvancedSearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
    self.filters = loadFilters() // TODO: - may be via input
  }
}

// MARK: - AdvancedSearchInteractorProtocol

extension AdvancedSearchInteractor: AdvancedSearchInteractorProtocol {

  func viewDidLoad() {
    presenter.update(filters: filters, selectedFilters: selectedFilters, sec: nil)
  }

  func didSelectItem(at indexPath: IndexPath) {

    if selectedFilters.contains(where: { $0 == filters[indexPath.section].items[indexPath.row] }) {
      selectedFilters.removeAll(where: { $0 == filters[indexPath.section].items[indexPath.row] })
    } else {
      selectedFilters.append(filters[indexPath.section].items[indexPath.row])
    }

    presenter.update(
      filters: filters,
      selectedFilters: selectedFilters,
      sec: indexPath.section)
  }
}
