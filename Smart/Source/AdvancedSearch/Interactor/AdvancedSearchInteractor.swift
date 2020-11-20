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
  private let initialFilters: [Filter]
  private var filters: [Filter]
  private var selectedFilters: [FilterItem] = []

  init(
    router: AdvancedSearchRouterProtocol,
    presenter: AdvancedSearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
    self.initialFilters = loadFilters()
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

  func didTapShowAll(at section: Int) {
    switch filters[section].category {
    case .country:
      let preSelectedCountryCodes: [String] =
        selectedFilters
        .filter ({ $0.category == .country })
        .compactMap({ $0.title })
      router.presentAllCountries(preSelectedCountryCodes: preSelectedCountryCodes)

    case .type, .color, .sugar:
      break
    }
  }

  func didChooseCountryCodes(_ countryCodes: [String]) {

    var filterItems: [FilterItem] = []
    countryCodes.forEach { code in
      let filterItem = FilterItem(title: code, imageName: code, category: .country)
      filterItems.append(filterItem)
      if !selectedFilters.contains(filterItem) {
        selectedFilters.append(filterItem)
      }
    }

    let items: [FilterItem] = {
      if filterItems.isEmpty {
        selectedFilters.removeAll(where: { $0.category == .country })
        return initialFilters.first(where: { $0.category == .country })?.items ?? []
      }
      return filterItems
    }()

    let filter = Filter(category: .country, items: items)

    if let index = filters.firstIndex(where: { $0.category == .country }) {
      filters[index] = filter
    }

    presenter.update(
      filters: filters,
      selectedFilters: selectedFilters,
      sec: nil)
  }

  func didTapConfirmSearchButton() {

    guard !selectedFilters.isEmpty else {
      return // TODO: - alert no one filter selected
    }

    let params: [(String, String)] = selectedFilters.compactMap ({ ($0.category.serverName, $0.title) })
    router.pushToSearchResultsController(navigationTitle: nil, params: params)
  }

  func didTapResetAllFiltersButton() {

    guard !selectedFilters.isEmpty else {
      return
    }

    filters = loadFilters()
    selectedFilters = []
    presenter.update(
      filters: initialFilters,
      selectedFilters: selectedFilters,
      sec: nil)
  }
}
