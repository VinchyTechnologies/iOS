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

  func update(wines: [ShortWine], needLoadMore: Bool) {
    var items: [ShowcaseViewModel.Item] = []

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

      items += [.title(itemID: UUID(), content: localized("all").firstLetterUppercased())]

      let winesContent = wines.compactMap({
        WineBottleView.Content(
          wineID: $0.wineID,
          imageURL: $0.imageURL,
          titleText: $0.titleText,
          subtitleText: $0.subtitleText,
          rating: $0.rating,
          buttonText: nil,
          flag: nil,
          contextMenuViewModels: [])
      })

      items += winesContent.compactMap({ .bottle(itemID: UUID(), content: $0) })

      if needLoadMore {
        items.append(.loading)
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

    let title: String?
    switch input.mode {
    case .normal, .partner:
      title = input.title

    case .advancedSearch:
      title = input.title //localized("search_results").firstLetterUppercased()
    }

    let tabViewModel: TabViewModel = .init(items: items.compactMap({ sec in
      switch sec {
      case .title(_, let content):
        return .init(titleText: content)

      case .loading, .bottle:
        return nil
      }
    }), initiallySelectedIndex: 0)

    let viewModel = ShowcaseViewModel(state: .normal(header: tabViewModel, sections: [.content(dataID: .content, items: items)]), navigationTitle: title, isSharable: true)
    viewController?.updateUI(viewModel: viewModel)
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showNothingFoundErrorView() {
    viewController?.updateUI(viewModel: .init(state: .error(sections: [.common(content: .init(titleText: localized("nothing_found").firstLetterUppercased(), subtitleText: nil, buttonText: nil))]), navigationTitle: nil, isSharable: false))
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
        isSharable: false))
  }
}
