//
//  StorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import StringFormatting

// MARK: - StorePresenter

final class StorePresenter {

  // MARK: Lifecycle

  init(input: StoreInput, viewController: StoreViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoreViewControllerProtocol?

  // MARK: Private

  private var input: StoreInput

  private var contextMenuViewModels: [ContextMenuViewModel] {
    if input.isAppClip {
      return []
    } else {
      return [
        .share(content: .init(title: localized("share_link").firstLetterUppercased())),
        .writeNote(content: .init(title: localized("write_note").firstLetterUppercased())),
      ]
    }
  }
}

// MARK: StorePresenterProtocol

extension StorePresenter: StorePresenterProtocol {
  func showNetworkErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func setLoadingFilters(data: StoreInteractorData) {
    var sections: [StoreViewModel.Section] = []

    sections += [
      .logo(itemID: .logoItem, .init(title: data.partnerInfo.title, logoURL: data.partnerInfo.logoURL)),
    ]

    if let addressText = data.partnerInfo.address {
      let isMapButtonHidden = data.partnerInfo.latitude == nil || data.partnerInfo.longitude == nil
      sections += [.address(StoreMapRow.Content(title: addressText, isMapButtonHidden: isMapButtonHidden))]
    }

//    if !data.recommendedWines.isEmpty {
//      sections += [.title(localized("vinchy_recommends").firstLetterUppercased())]
//
//      let winesContent = data.recommendedWines.map { wine in
//        WineBottleView.Content(
//          wineID: wine.id,
//          imageURL: wine.mainImageUrl?.toURL,
//          titleText: wine.title,
//          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode),
//          rating: wine.rating,
//          buttonText: "$255",
//          contextMenuViewModels: contextMenuViewModels)
//      }
//
//      sections += [.wines(winesContent)]
//    }

    sections += [.loading(itemID: .loadingItem, shouldCallWillDisplay: false)]

    let viewModel = StoreViewModel(sections: sections, navigationTitleText: data.partnerInfo.title, shouldResetContentOffset: true)
    viewController?.updateUI(viewModel: viewModel)
  }

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
      let isMapButtonHidden = data.partnerInfo.latitude == nil || data.partnerInfo.longitude == nil
      sections += [.address(StoreMapRow.Content(title: addressText, isMapButtonHidden: isMapButtonHidden))]
    }

    if !data.recommendedWines.isEmpty, data.selectedFilters.isEmpty {
      sections += [.title(localized("vinchy_recommends").firstLetterUppercased())]

      let winesContent: [WineBottleView.Content] = data.recommendedWines.compactMap { wine in
        let buttonText: String? = {
          if let amount = wine.price?.amount, let currency = wine.price?.currencyCode {
            return formatCurrencyAmount(amount, currency: currency)
          }
          return nil
        }()
        return WineBottleView.Content(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode),
          rating: wine.rating,
          buttonText: buttonText,
          contextMenuViewModels: contextMenuViewModels)
      }

      sections += [.wines(winesContent)]
    }

    if !data.assortimentWines.isEmpty {

      let winesContent: [HorizontalWineView.Content] = data.assortimentWines.map({ wine in
        let buttonText: String? = {
          if let amount = wine.price?.amount, let currency = wine.price?.currencyCode {
            return formatCurrencyAmount(amount, currency: currency)
          }
          return nil
        }()
        return HorizontalWineView.Content.init(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: wine.winery?.title,
          buttonText: buttonText)
      })

      var assortmentsContent = [StoreViewModel.AssortimentContent]()

      assortmentsContent.append(.contentCoulBeNotRight(content: localized("wines_assortiment_could_be_not_right").firstLetterUppercased()))

      winesContent.enumerated().forEach { index, wineContent in
        if index % 10 == 0 && index != 0 {
          assortmentsContent.append(.ad(itemID: .ad))
        }
        assortmentsContent.append(.horizontalWine(wineContent))
      }

      if data.selectedFilters.isEmpty {
        sections += [.assortiment(header: [localized("all").firstLetterUppercased()], content: assortmentsContent)]
      } else {
        let header: [String] = data.selectedFilters.compactMap({
          if $0.0 == "country_code" {
            return countryNameFromLocaleCode(countryCode: $0.1)
          } else {
            return localized($0.1).firstLetterUppercased()
          }
        })
        sections += [.assortiment(header: header, content: assortmentsContent)]
      }

      if needLoadMore {
        sections += [.loading(itemID: .loadingItem, shouldCallWillDisplay: true)]
      }
    } else {

      if !data.selectedFilters.isEmpty {

        let assortmentsContent: [StoreViewModel.AssortimentContent] = [
          .empty(
            itemID: .strongFilters,
            content: EmptyView.Content(
              titleText: localized("nothing_found").firstLetterUppercased(),
              subtitleText: nil,
              buttonText: nil)),
        ]

        let header: [String] = data.selectedFilters.compactMap({
          if $0.0 == "country_code" {
            return countryNameFromLocaleCode(countryCode: $0.1)
          } else {
            return localized($0.1).firstLetterUppercased()
          }
        })
        sections += [.assortiment(header: header, content: assortmentsContent)]
      }
    }

    let viewModel = StoreViewModel(sections: sections, navigationTitleText: data.partnerInfo.title, shouldResetContentOffset: false)
    viewController?.updateUI(viewModel: viewModel)
  }
}
