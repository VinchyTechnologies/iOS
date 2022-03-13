//
//  ShowcasePresenter.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import DisplayMini
import EpoxyCollectionView
import Foundation
import StringFormatting
import VinchyCore
import VinchyUI

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

  func update(title: String?, wines: [ShortWine], needLoadMore: Bool) {
    var items: [ShowcaseViewModel.Item] = []
    var title = title

    var isSharable = false

    switch input.mode {
    case .advancedSearch, .questions:
      isSharable = false

    case .remote:
      isSharable = true
    }

    switch input.mode {
    case .advancedSearch, .questions:
      items += [.title(itemID: UUID(), content: localized("all").firstLetterUppercased())]

      let winesContent: [WineBottleView.Content] = wines.compactMap({
        var buttonText: String?
        if let amount = $0.price?.amount, let currencyCode = $0.price?.currencyCode {
          buttonText = formatCurrencyAmount(amount, currency: currencyCode)
        }
        return WineBottleView.Content(
          wineID: $0.id,
          imageURL: $0.mainImageUrl?.toURL,
          titleText: $0.title,
          subtitleText: $0.winery?.region,
          rating: $0.rating,
          buttonText: buttonText,
          flag: emojiFlagForISOCountryCode($0.winery?.countryCode ?? ""),
          contextMenuViewModels: [])
      })

      items += winesContent.compactMap({ .bottle(itemID: UUID(), content: $0) })

      if needLoadMore {
        items.append(.loading)
      }

    case .remote:
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

      groupedWines.enumerated().forEach { index, arrayShortWines in
        items += [
          .title(itemID: index, content: countryNameFromLocaleCode(
            countryCode: arrayShortWines.first?.winery?.countryCode) ?? ""),
        ]
        let winesContent = arrayShortWines.compactMap { wine -> WineBottleView.Content in
          WineBottleView.Content(
            wineID: wine.id,
            imageURL: wine.mainImageUrl?.toURL,
            titleText: wine.title,
            subtitleText: wine.winery?.title,
            rating: wine.rating,
            buttonText: nil,
            flag: emojiFlagForISOCountryCode(wine.winery?.countryCode ?? ""),
            contextMenuViewModels: [])
        }
        items += winesContent.enumerated().compactMap({ .bottle(itemID: ItemPath(itemDataID: "item\($0)", section: .dataID("sec\(index)")) , content: $1) })
      }
    }

    switch input.mode {
    case .advancedSearch:
      title = input.title ?? localized("search_results").firstLetterUppercased()

    case .questions:
      title = "Мы рекомендуем"

    case .remote:
      break
    }

    let tabViewModel: TabViewModel = .init(items: items.compactMap({ sec in
      switch sec {
      case .title(_, let content):
        return .init(titleText: content)

      case .loading, .bottle:
        return nil
      }
    }), initiallySelectedIndex: 0)

    var bottomBarViewModel: BottomPriceBarView.Content?
    switch input.mode {
    case .advancedSearch, .remote:
      bottomBarViewModel = nil

    case .questions:
      bottomBarViewModel = .init(leadingText: nil, trailingButtonText: "Пройти заново")
    }

    let viewModel = ShowcaseViewModel(state: .normal(header: tabViewModel, sections: [.content(dataID: .content, items: items)]), navigationTitle: title, isSharable: isSharable, bottomBarViewModel: bottomBarViewModel)
    viewController?.updateUI(viewModel: viewModel)
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showNothingFoundErrorView() {
    var bottomBarViewModel: BottomPriceBarView.Content?
    switch input.mode {
    case .advancedSearch, .remote:
      bottomBarViewModel = nil

    case .questions:
      bottomBarViewModel = .init(leadingText: nil, trailingButtonText: "Пройти заново")
    }
    viewController?.updateUI(viewModel: .init(state: .error(sections: [.common(content: .init(titleText: localized("nothing_found").firstLetterUppercased(), subtitleText: nil, buttonText: nil))]), navigationTitle: nil, isSharable: false, bottomBarViewModel: bottomBarViewModel))
  }

  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      viewModel: .init(
        state: .error(
          sections: [
            .common(
              content: .init(
                titleText: localized("error").firstLetterUppercased(),
                subtitleText: error.localizedDescription,
                buttonText: localized("reload").firstLetterUppercased())),
          ]),
        navigationTitle: nil,
        isSharable: false,
        bottomBarViewModel: nil))
  }
}
