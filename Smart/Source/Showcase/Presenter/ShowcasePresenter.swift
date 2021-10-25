//
//  ShowcasePresenter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import StringFormatting
import VinchyCore

// MARK: - ShowcasePresenter

final class ShowcasePresenter {

  // MARK: Lifecycle

  init(input: ShowcaseInput, viewController: ShowcaseViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Private

  private var input: ShowcaseInput
  private weak var viewController: ShowcaseViewControllerProtocol?
}

// MARK: ShowcasePresenterProtocol

extension ShowcasePresenter: ShowcasePresenterProtocol {
  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func update(wines: [ShortWine], needLoadMore: Bool) {
    var sections: [ShowcaseViewModel.Section] = []

    switch input.mode {
    case .advancedSearch, .partner:
      let wines = wines.compactMap { wine -> WineCollectionViewCellViewModel? in
        WineCollectionViewCellViewModel(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode),
          rating: wine.rating,
          contextMenuViewModels: [])
      }
      sections = [.shelf(title: localized("all").firstLetterUppercased(), wines: wines)]
      if needLoadMore {
        sections.append(.loading)
      }

    case .normal:
      var groupedWines = wines.grouped(map: { $0.winery?.countryCode ?? localized("unknown_country_code") })

      groupedWines.sort { arr1, arr2 -> Bool in
        if
          let w1 = countryNameFromLocaleCode(countryCode: arr1.first?.winery?.countryCode),
          let w2 = countryNameFromLocaleCode(countryCode: arr2.first?.winery?.countryCode)
        {
          return w1 < w2
        }
        return false
      }
      sections = groupedWines.map { arrayWine -> ShowcaseViewModel.Section in
        let wines = arrayWine.compactMap { wine -> WineCollectionViewCellViewModel? in
          WineCollectionViewCellViewModel(
            wineID: wine.id,
            imageURL: wine.mainImageUrl?.toURL,
            titleText: wine.title,
            subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode),
            rating: wine.rating,
            contextMenuViewModels: [])
        }
        return .shelf(
          title: countryNameFromLocaleCode(
            countryCode: arrayWine.first?.winery?.countryCode) ?? localized("unknown_country_code"),
          wines: wines)
      }
    }

    let title: String?
    switch input.mode {
    case .normal, .partner:
      title = input.title

    case .advancedSearch:
      title = localized("search_results").firstLetterUppercased()
    }

    let tabViewModel: TabViewModel = .init(items: sections.compactMap({ sec in
      switch sec {
      case .shelf(let title, _):
        return .init(titleText: title)

      case .loading:
        return nil
      }
    }), initiallySelectedIndex: 0)

    let viewModel = ShowcaseViewModel(navigationTitle: title, sections: sections, tabViewModel: tabViewModel)
    viewController?.updateUI(viewModel: viewModel)
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showNothingFoundErrorView() {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("nothing_found").firstLetterUppercased(),
        subtitleText: nil,
        buttonText: nil))
  }

  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("error").firstLetterUppercased(),
        subtitleText: error.localizedDescription,
        buttonText: localized("reload").firstLetterUppercased()))
  }
}
