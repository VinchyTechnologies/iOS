//
//  AdvancedSearchPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import CommonUI
import StringFormatting

fileprivate extension FilterCategory {
  var title: String {
    switch self {
    case .type:
      return localized("type").firstLetterUppercased()

    case .color:
      return localized("color").firstLetterUppercased()

    case .country:
      return localized("country").firstLetterUppercased()

    case .sugar:
      return localized("sugar").firstLetterUppercased()
    }
  }
}

fileprivate enum C {
  static let navigationTitle = localized("advanced_search")
  static let moreText = "More"
}

final class AdvancedSearchPresenter {
  
  private typealias ViewModel = AdvancedSearchViewModel
  
  weak var viewController: AdvancedSearchViewControllerProtocol?
  
  init(viewController: AdvancedSearchViewControllerProtocol) {
    self.viewController = viewController
  }
}

// MARK: - AdvancedSearchPresenterProtocol

extension AdvancedSearchPresenter: AdvancedSearchPresenterProtocol {

  func update(filters: [Filter], selectedFilters: [FilterItem], sec: Int?) {

    var sections = [ViewModel.Section]()

    filters.forEach { filter in
      switch filter.category {
      case .type, .color, .sugar:

        var items = [AdvancedSearchCaruselCollectionCellViewModel]()

        let cells = filter.items.map { filterItem -> ImageOptionCollectionCellViewModel in
          .init(
            imageName: filterItem.imageName,
            titleText: filterItem.title,
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
        break
      }
    }

    let viewModel = ViewModel(sections: sections, navigationTitle: C.navigationTitle)
    viewController?.updateUI(viewModel: viewModel, sec: sec)
  }
}
