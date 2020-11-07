//
//  AdvancedSearchPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import CommonUI

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
      case .type:

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

        sections.append(.carusel(title: "Type", items: items))

      case .color:
        break

      case .country:
        break

      case .sugar:
        break
      }
    }

    viewController?.updateUI(viewModel: ViewModel(sections: sections), sec: sec)
  }
}
