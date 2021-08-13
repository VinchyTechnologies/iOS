//
//  StorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import StringFormatting

// MARK: - StorePresenter

final class StorePresenter {

  // MARK: Lifecycle

  init(viewController: StoreViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoreViewControllerProtocol?

}

// MARK: StorePresenterProtocol

extension StorePresenter: StorePresenterProtocol {

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("error").firstLetterUppercased(),
        subtitleText: error.localizedDescription,
        buttonText: localized("reload").firstLetterUppercased()))
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func update(data: StoreInteractorData, needLoadMore: Bool) {

    var sections: [StoreViewModel.Section] = []

    sections += [
      .logo(itemID: .logoItem, .init(title: data.partnerInfo.title, logoURL: data.partnerInfo.logoURL)),
    ]

    if let addressText = data.partnerInfo.address {
      sections += [.address(addressText)]
    }

    if !data.recommendedWines.isEmpty {
      sections += [.title(localized("vinchy_recommends").firstLetterUppercased())]

      let winesContent = data.recommendedWines.map { wine in
        WineBottleView.Content(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode))
      }

      sections += [.wines(winesContent)]
    }

    if !data.assortimentWines.isEmpty {

      let winesContent: [HorizontalWineView.Content] = data.assortimentWines.map({ wine in
        HorizontalWineView.Content.init(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode))
      })

      var assortmentsContent = [StoreViewModel.AssortimentContent]()
      winesContent.enumerated().forEach { index, wineContent in
        if index % 10 == 0 && index != 0 && isAdAvailable {
          assortmentsContent.append(.ad(itemID: .ad))
        }
        assortmentsContent.append(.horizontalWine(wineContent))
      }

      sections += [.assortiment(header: [localized("all").firstLetterUppercased()], content: assortmentsContent)]

      if needLoadMore {
        sections += [.loading(itemID: .loadingItem)]
      }
    }

    let viewModel = StoreViewModel(sections: sections, navigationTitleText: data.partnerInfo.title)
    viewController?.updateUI(viewModel: viewModel)
  }
}
