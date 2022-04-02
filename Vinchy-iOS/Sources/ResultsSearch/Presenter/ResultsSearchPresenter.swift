//
//  ResultsSearchPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import DisplayMini
import StringFormatting
import UIKit
import VinchyCore

// MARK: - ResultsSearchPresenter

final class ResultsSearchPresenter {

  // MARK: Lifecycle

  init(input: ResultsSearchInput, viewController: ResultsSearchViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: ResultsSearchViewControllerProtocol?

  // MARK: Private

  private let input: ResultsSearchInput

}

// MARK: ResultsSearchPresenterProtocol

extension ResultsSearchPresenter: ResultsSearchPresenterProtocol {
  func update(didFindWines: [ShortWine]) {

    var sections: [ResultsSearchViewModel.Section] = []

    if didFindWines.isEmpty, case .normal = input.mode {
      sections.append(
        .didnotFindWine(
          content: .init(
            titleText: localized("did_not_find_the_wine").firstLetterUppercased(),
            writeUsButtonText: localized("write_us").firstLetterUppercased())))
      viewController?.updateUI(viewModel: .init(sections: sections))
    } else {
      didFindWines.forEach { wine in
        let oldPriceText: String? = {
          if let amount = wine.oldPrice?.amount, let currency = wine.oldPrice?.currencyCode {
            return formatCurrencyAmount(amount, currency: currency)
          }
          return nil
        }()

        let subtitleText: String? = {
          var result = ""
          let flag = emojiFlagForISOCountryCode(wine.winery?.countryCode ?? "")
          if let subtitleText = wine.winery?.title {
            if !flag.isEmpty {
              result += flag + " " + subtitleText
            } else {
              result += subtitleText
            }
          }
          return result.isEmpty ? nil : result
        }()

        sections.append(.horizontalWine(
          content: .init(
            wineID: wine.id,
            imageURL: wine.mainImageUrl?.toURL,
            titleText: wine.title,
            subtitleText: subtitleText,
            buttonText: nil,
            oldPriceText: oldPriceText,
            badgeText: wine.discountText,
            rating: wine.rating)))
      }
      viewController?.updateUI(viewModel: .init(sections: sections))
    }
  }

  func update(searchedWines: [VSearchedWine]) {

    var sections: [ResultsSearchViewModel.Section] = []
    var wineCollectionViewCellViewModels: [WineBottleView.Content] = []

    searchedWines.forEach { wine in
      wineCollectionViewCellViewModels.append(
        .init(
          wineID: wine.wineID,
          imageURL: imageURL(from: wine.wineID).toURL,
          titleText: wine.title,
          subtitleText: nil,
          rating: nil,
          buttonText: nil,
          flag: nil,
          contextMenuViewModels: []))
    }

    if !wineCollectionViewCellViewModels.isEmpty {
      sections.append(.title(content: localized("recently_searched").firstLetterUppercased()))
    }

    sections.append(.recentlySearched(content: .init(wines: wineCollectionViewCellViewModels.reversed())))
    viewController?.updateUI(viewModel: .init(sections: sections))
  }
}
