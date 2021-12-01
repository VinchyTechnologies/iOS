//
//  AdvancedSearchInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyUI

// MARK: - AdvancedSearchInteractor

final class AdvancedSearchInteractor {

  // MARK: Lifecycle

  init(
    input: AdvancedSearchInput,
    router: AdvancedSearchRouterProtocol,
    presenter: AdvancedSearchPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    initialFilters = loadFilters()
    filters = loadFilters() // TODO: - may be via input

    switch input.mode {
    case .normal:
      filters = loadFilters()
      selectedFilters = []

    case .asView(let preselectedFilters):
      filters = loadFilters()

      var selectedFilters: [FilterItem] = []
      preselectedFilters.forEach { category, value in
        let filterItems = initialFilters.first(where: { $0.category.serverName == category })
        if let item = filterItems?.items.first(where: { $0.title == value }) {
          selectedFilters.append(item)
        }
      }
      self.selectedFilters = selectedFilters

      let countryItems = initialFilters.first(where: { $0.category == .country })?.items.compactMap({ $0.title })
      let countryPreselectedFilters = preselectedFilters.filter({ $0.0 == "country_code" }).compactMap({ $0.1 })
      if !countryPreselectedFilters.allSatisfy({ countryItems?.contains($0) == true }) {
        var filterItems: [FilterItem] = []
        selectedFilters.removeAll(where: { $0.category == .country })
        countryPreselectedFilters.forEach { code in
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
      }

      preselectedFilters.forEach { category, value in
        let filterItems = initialFilters.first(where: { $0.category.serverName == category })
        if let item = filterItems?.items.first(where: { $0.title == value }) {
          if !selectedFilters.contains(item) {
            selectedFilters.append(item)
          }
        }
      }
      self.selectedFilters = selectedFilters
    }
  }

  // MARK: Private

  private let input: AdvancedSearchInput
  private let router: AdvancedSearchRouterProtocol
  private let presenter: AdvancedSearchPresenterProtocol
  private let initialFilters: [Filter]
  private var filters: [Filter]
  private var selectedFilters: [FilterItem] = []
}

// MARK: AdvancedSearchInteractorProtocol

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
          .filter { $0.category == .country }
          .compactMap { $0.title }
      router.presentAllCountries(preSelectedCountryCodes: preSelectedCountryCodes)

    case .type, .color, .sugar, .compatibility:
      break
    }
  }

  func didChooseCountryCodes(_ countryCodes: [String]) {
    var filterItems: [FilterItem] = []
    selectedFilters.removeAll(where: { $0.category == .country })
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

    switch input.mode {
    case .normal:
      guard !selectedFilters.isEmpty else {
        return // TODO: - alert no one filter selected
      }
      let params: [(String, String)] = selectedFilters.compactMap { ($0.category.serverName, $0.title) }
      router.pushToShowcaseViewController(input: .init(title: nil, mode: .advancedSearch(params: params)))

    case .asView:
      let params: [(String, String)] = selectedFilters.compactMap { ($0.category.serverName, $0.title) }
      router.dismiss(selectedFilters: params)
    }
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
