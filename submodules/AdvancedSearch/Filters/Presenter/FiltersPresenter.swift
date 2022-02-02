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

}

// MARK: FiltersPresenterProtocol

extension FiltersPresenter: FiltersPresenterProtocol {

  func update(filters: [Filter], selectedFilters: [(String, String)], reloadingData: Bool) {
    var sections = [FiltersViewModel.Section]()

    filters.forEach { filter in

      if filter.category == .country {
        sections += [.countryTitle(content: .init(titleText: localized(filter.category.rawValue).firstLetterUppercased(), moreText: localized("see_all").firstLetterUppercased(), shouldShowMoreText: true))]
      } else {
        sections += [.title(content: localized(filter.category.rawValue).firstLetterUppercased())]
      }

      if filter.category == .country {
        if
          selectedFilters.allSatisfy({ selectedFilter in
            if selectedFilter.0 == "country" {
              if let filter = filters.first(where: { $0.category == .country }) {
                return filter.items.contains(where: { $0.title == selectedFilter.1 })
              }
              return true
            }
            return true
          })
        {
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
        } else {
          let items: [ServingTipsCollectionViewItem] = selectedFilters.compactMap { filterItem in
            var titleText: String? = localized(filterItem.1.lowercased()).firstLetterUppercased()
            var image: UIImage?
            if filter.category == .country {
              titleText = countryNameFromLocaleCode(countryCode: filterItem.1)
              image = UIImage(named: filterItem.1)
            }
            let isSelected = true
            let content: ImageOptionView.Content = .init(
              filterItem: FilterItem(title: filterItem.1, imageName: filterItem.1, category: .country),
              image: image,
              titleText: titleText,
              isSelected: isSelected)
            return .imageOption(content: content)
          }
          sections += [.carousel(dataID: filter.category.rawValue, content: .init(items: items))]
        }
      } else {
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
      }
    }
    var bottomBarViewModel: BottomButtonsView.Content?
    if !selectedFilters.isEmpty {
      bottomBarViewModel = .init(
        leadingButtonText: localized("reset").firstLetterUppercased(),
        trailingButtonText: localized("search").firstLetterUppercased())
    }

    let viewModel = FiltersViewModel(sections: sections, navigationTitleText: localized("advanced_search"), bottomBarViewModel: bottomBarViewModel)
    viewController?.updateUI(viewModel: viewModel, reloadingData: reloadingData)
  }
}
