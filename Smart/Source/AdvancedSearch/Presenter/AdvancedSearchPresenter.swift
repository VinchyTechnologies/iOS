//
//  AdvancedSearchPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import StringFormatting

extension FilterCategory {
  fileprivate var title: String {
    switch self {
    case .type:
      return localized("type").firstLetterUppercased()

    case .color:
      return localized("color").firstLetterUppercased()

    case .country:
      return localized("country").firstLetterUppercased()

    case .sugar:
      return localized("sugar").firstLetterUppercased()

    case .compatibility:
      return localized("compatibility").firstLetterUppercased()
    }
  }
}

// MARK: - C

private enum C {
  static let navigationTitle = localized("advanced_search")
  static let moreText = localized("see_all") // TODO: - capitalized with locale
}

// MARK: - AdvancedSearchPresenter

final class AdvancedSearchPresenter {

  // MARK: Lifecycle

  init(viewController: AdvancedSearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: AdvancedSearchViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = AdvancedSearchViewModel
}

// MARK: AdvancedSearchPresenterProtocol

extension AdvancedSearchPresenter: AdvancedSearchPresenterProtocol {
  func update(filters: [Filter], selectedFilters: [FilterItem], sec: Int?) {
    var sections = [ViewModel.Section]()

    filters.forEach { filter in
      switch filter.category {
      case .type, .color, .sugar, .compatibility:

        var items = [AdvancedSearchCaruselCollectionCellViewModel]()

        let cells = filter.items.map { filterItem -> ImageOptionCollectionCellViewModel in
          .init(
            image: UIImage(named: filterItem.imageName?.lowercased() ?? ""),
            titleText: localized(filterItem.title.lowercased()).firstLetterUppercased(),
            isSelected: selectedFilters.contains(filterItem))
        }

        items.append(
          AdvancedSearchCaruselCollectionCellViewModel(
            items: cells,
            shouldLoadMore: false))

        sections.append(.carusel(
          headerViewModel: .init(
            titleText: filter.category.title,
            moreText: C.moreText,
            shouldShowMore: false),
          items: items))

      case .country:
        var items = [AdvancedSearchCaruselCollectionCellViewModel]()

        let cells = filter.items.map { filterItem -> ImageOptionCollectionCellViewModel in
          .init(
            image: UIImage(named: filterItem.imageName ?? ""),
            titleText: countryNameFromLocaleCode(countryCode: filterItem.title),
            isSelected: selectedFilters.contains(filterItem))
        }

        items.append(
          AdvancedSearchCaruselCollectionCellViewModel(
            items: cells,
            shouldLoadMore: false))

        sections.append(.carusel(
          headerViewModel: .init(
            titleText: localized(filter.category.title),
            moreText: C.moreText,
            shouldShowMore: true),
          items: items))
      }
    }

    let bottomButtonsViewModel = BottomButtonsViewModel(
      leadingButtonText: localized("reset").firstLetterUppercased(),
      trailingButtonText: localized("search").firstLetterUppercased())

    let viewModel = ViewModel(
      sections: sections,
      navigationTitle: C.navigationTitle,
      bottomButtonsViewModel: bottomButtonsViewModel, isBottomButtonsViewHidden: selectedFilters.isEmpty)
    viewController?.updateUI(viewModel: viewModel, sec: sec)
  }
}
