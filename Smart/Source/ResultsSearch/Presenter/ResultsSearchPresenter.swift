//
//  ResultsSearchPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - ResultsSearchPresenter

final class ResultsSearchPresenter {

  // MARK: Lifecycle

  init(viewController: ResultsSearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: ResultsSearchViewControllerProtocol?

}

// MARK: ResultsSearchPresenterProtocol

extension ResultsSearchPresenter: ResultsSearchPresenterProtocol {
  func update(didFindWines: [ShortWine]) {

    var sections: [ResultsSearchViewModel.ResultsSection] = []

    if didFindWines.isEmpty {
      sections.append(.didNotFindTheWine([.init(titleText: localized("did_not_find_the_wine"), writeUsButtonText: localized("write_us").firstLetterUppercased())]))
      viewController?.updateUI(viewModel: .init(state: .results(sections: sections)))

    } else {
      var wineCollectionCellViewModels: [WineCollectionCellViewModel] = []

      didFindWines.forEach { wine in
        wineCollectionCellViewModels.append(.init(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText:
          countryNameFromLocaleCode(countryCode: wine.winery?.countryCode)))

      }
      sections.append(.searchResults(wineCollectionCellViewModels))
      viewController?.updateUI(viewModel: .init(state: .results(sections: sections)))
    }
  }

  func update(searchedWines: [VSearchedWine]) {

    var sections: [ResultsSearchViewModel.HistorySection] = []
    var wineCollectionViewCellViewModels: [WineCollectionViewCellViewModel] = []

    searchedWines.forEach { wine in
      wineCollectionViewCellViewModels.append(
        .init(
          wineID: wine.wineID,
          imageURL: imageURL(from: wine.wineID).toURL,
          titleText: wine.title,
          subtitleText: nil,
          contextMenuViewModels: []))
    }

    if !wineCollectionViewCellViewModels.isEmpty {
      sections.append(.titleRecentlySearched(
        [.init(titleText: NSAttributedString(
          string: localized("recently_searched").firstLetterUppercased(),
          font: Font.heavy(20),
          textColor: .dark))]
      ))
    }
    sections.append(.recentlySearched(wineCollectionViewCellViewModels.reversed()))
    viewController?.updateUI(viewModel: .init(state: .history(sections: sections)))
  }
}
