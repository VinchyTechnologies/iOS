//
//  FiltersPresenter.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import Core
import DisplayMini
import StringFormatting
import UIKit

// MARK: - FiltersPresenter

final class FiltersPresenter {

  // MARK: Lifecycle

  init(viewController: FiltersViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: FiltersViewControllerProtocol?

  // MARK: Private

  private func mapNormalFilter(selectedFilters: [(String, String)], filter: Filter, shouldAddHeader: Bool = true) -> [FiltersViewModel.Section] {
    var sections = [FiltersViewModel.Section]()

    if shouldAddHeader {
      sections += [.title(content: localized(filter.category.rawValue).firstLetterUppercased())]
    }

    let items: [ServingTipsCollectionViewItem] = filter.items.compactMap { filterItem in
      var titleText: String? = localized(filterItem.title.lowercased()).firstLetterUppercased()
      var image: UIImage?
      if filter.category == .country {
        titleText = countryNameFromLocaleCode(countryCode: filterItem.title)
        image = UIImage(named: filterItem.imageName ?? "")
      }
      if filter.category == .compatibility {
        image = UIImage(named: filterItem.imageName?.lowercased() ?? "")?.withTintColor(.dark, renderingMode: .alwaysOriginal)
      }
      let isSelected = selectedFilters.contains(where: { $0.0 == filterItem.category.rawValue && $0.1 == filterItem.title })
      let content: ImageOptionView.Content = .init(
        filterItem: filterItem,
        image: image,
        titleText: titleText,
        isSelected: isSelected)
      return .imageOption(content: content)
    }
    sections += [.carousel(dataID: filter.category.rawValue, content: .init(items: items))]
    return sections
  }

  private func mapCountryFilter(selectedFilters: [(String, String)], filter: Filter) -> [FiltersViewModel.Section] {
    var sections = [FiltersViewModel.Section]()
    sections += [.countryTitle(content: .init(titleText: localized(filter.category.rawValue).firstLetterUppercased(), moreText: localized("see_all").firstLetterUppercased(), shouldShowMoreText: true))]
    let selectedFilters = selectedFilters.filter({ $0.0 == "country" })
    let filterItems = filter.items
    if
      selectedFilters.allSatisfy({ selectedFilter in
        filterItems.contains(where: { $0.title == selectedFilter.1 })
      })
    {
      sections += mapNormalFilter(selectedFilters: selectedFilters, filter: filter, shouldAddHeader: false)
    } else {
      let items: [ServingTipsCollectionViewItem] = selectedFilters.compactMap { selectedFilter in
        let image = UIImage(named: selectedFilter.1)
        let isSelected = true
        let content: ImageOptionView.Content = .init(
          filterItem: .init(title: selectedFilter.1, imageName: selectedFilter.1, category: .country),
          image: image,
          titleText: countryNameFromLocaleCode(countryCode: selectedFilter.1),
          isSelected: isSelected)
        return .imageOption(content: content)
      }
      sections += [.carousel(dataID: filter.category.rawValue, content: .init(items: items))]
    }
    return sections
  }
}

// MARK: FiltersPresenterProtocol

extension FiltersPresenter: FiltersPresenterProtocol {

  func update(filters: [Filter], selectedFilters: [(String, String)], reloadingData: Bool) {
    var sections = [FiltersViewModel.Section]()
    sections += [.title(content: "Цена, ₽")]
    let minPrice = selectedFilters.first(where: { $0.0 == "min_price" })?.1
    let maxPrice = selectedFilters.first(where: { $0.0 == "max_price" })?.1
    sections += [.price(content: .init(minPrice: minPrice, maxPrice: maxPrice, minPlaceHolderText: "От", maxPlaceHolderText: "До", decimalDigits: 2))] // TODO: - decimalDigits
    filters.forEach { filter in
      if filter.category == .country {
        sections += mapCountryFilter(selectedFilters: selectedFilters, filter: filter)
      } else {
        sections += mapNormalFilter(selectedFilters: selectedFilters, filter: filter)
      }
    }

    var bottomBarViewModel: BottomButtonsView.Content?
    bottomBarViewModel = .init(
      leadingButtonText: localized("reset").firstLetterUppercased(),
      trailingButtonText: localized("search").firstLetterUppercased())

    let viewModel = FiltersViewModel(sections: sections, navigationTitleText: localized("advanced_search"), bottomBarViewModel: bottomBarViewModel)
    viewController?.updateUI(viewModel: viewModel, reloadingData: reloadingData)
  }
}
