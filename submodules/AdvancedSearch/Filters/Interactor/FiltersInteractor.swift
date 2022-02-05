//
//  FiltersInteractor.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Core
import DisplayMini

// MARK: - FiltersInteractor

final class FiltersInteractor {

  // MARK: Lifecycle

  init(
    input: FiltersInput,
    router: FiltersRouterProtocol,
    presenter: FiltersPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    filters = loadFilters()
  }

  // MARK: Private

  private lazy var selectedFilters: [(String, String)] = input.preselectedFilters

  private let input: FiltersInput
  private let router: FiltersRouterProtocol
  private let presenter: FiltersPresenterProtocol
  private let filters: [Filter]
}

// MARK: FiltersInteractorProtocol

extension FiltersInteractor: FiltersInteractorProtocol {

  func didEnterMinMaxPrice(minPrice: Int?, maxPrice: Int?) {
    selectedFilters.removeAll(where: { $0.0 == "min_price" || $0.0 == "max_price" })
    if let minPrice = minPrice {
      selectedFilters.append(("min_price", String(minPrice)))
    }
    if let maxPrice = maxPrice {
      selectedFilters.append(("max_price", String(maxPrice)))
    }
    presenter.update(filters: filters, selectedFilters: selectedFilters, reloadingData: false)
  }

  func didTapConfirmFilters() {
    router.dismissWithFilters(selectedFilters)
  }

  func didChoose(countryCodes: [String]) {
    selectedFilters.removeAll(where: { $0.0 == "country" })
    countryCodes.forEach { code in
      selectedFilters.append(("country", code))
    }
    presenter.update(filters: filters, selectedFilters: selectedFilters, reloadingData: true)
  }

  func didTapSeeAllCounties() {
    let preSelectedCountryCodes: [String] = selectedFilters.compactMap({
      $0.0 == "country" ? $0.1 : nil
    })
    router.presentAllCountries(preSelectedCountryCodes: preSelectedCountryCodes)
  }

  func didTapResetAllFilters() {
    selectedFilters.removeAll()
    presenter.update(filters: filters, selectedFilters: selectedFilters, reloadingData: true)
  }

  func isSelected(item: ImageOptionView.Content) -> Bool {
    selectedFilters.contains(where: { $0.0 == item.filterItem?.category.rawValue && $0.1 == item.filterItem?.title })
  }

  func viewDidLoad() {
    presenter.update(filters: filters, selectedFilters: selectedFilters, reloadingData: true)
  }

  func didSelect(item: ImageOptionView.Content) {

    if isSelected(item: item) {
      selectedFilters.removeAll(where: { $0.0 == item.filterItem?.category.rawValue && $0.1 == item.filterItem?.title })
    } else {
      guard let title = item.filterItem?.title, let category = item.filterItem?.category.rawValue else {
        return
      }
      selectedFilters.append((category, title))
    }

    presenter.update(filters: filters, selectedFilters: selectedFilters, reloadingData: false)
  }
}
