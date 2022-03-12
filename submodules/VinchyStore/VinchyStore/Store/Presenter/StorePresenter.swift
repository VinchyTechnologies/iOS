//
//  StorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreGraphics
import Database
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

  func setLikedStatus(isLiked: Bool) {
    viewController?.setLikedStatus(isLiked: isLiked)
  }

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
      sections += [.address(StoreMapRow.Content(titleText: addressText, isMapButtonHidden: isMapButtonHidden))]
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

    let viewModel = StoreViewModel(sections: sections, navigationTitleText: data.partnerInfo.title, shouldResetContentOffset: true, isLiked: data.isLiked, bottomPriceBarViewModel: nil)
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

  func update(data: StoreInteractorData, needLoadMore: Bool, isBottomButtonLoading: Bool, totalPrice: Int64?, cartItems: [CartItem], recommendedWinesContentOffsetX: CGFloat) {

    var sections: [StoreViewModel.Section] = []

    sections += [
      .logo(itemID: .logoItem, .init(title: data.partnerInfo.title, logoURL: data.partnerInfo.logoURL)),
    ]

    if let addressText = data.partnerInfo.address {
      let isMapButtonHidden = data.partnerInfo.latitude == nil || data.partnerInfo.longitude == nil
      sections += [.address(StoreMapRow.Content(titleText: addressText, isMapButtonHidden: isMapButtonHidden))]
    }

    if !input.isAppClip && data.selectedFilters.isEmpty {
      sections += [
        .services(.init(
          isLiked: data.isLiked,
          saveButtonText: localized("save").firstLetterUppercased(),
          savedButtonText: localized("saved").firstLetterUppercased(),
          shareText: localized("share").firstLetterUppercased())),
      ]
    }

    if !data.recommendedWines.isEmpty, data.selectedFilters.isEmpty {
      sections += [.title(localized("vinchy_recommends").firstLetterUppercased())]

      let winesContent: [WineBottleView.Content] = data.recommendedWines.compactMap { wine in
        let buttonText: String? = {
          if cartItems.contains(where: { $0.productID == wine.id }) {
            return "✔︎"
          }
          if let amount = wine.price?.amount, let currency = wine.price?.currencyCode {
            return formatCurrencyAmount(amount, currency: currency)
          }
          return nil
        }()
        return WineBottleView.Content(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: wine.winery?.title,
          rating: wine.rating,
          buttonText: buttonText,
          flag: emojiFlagForISOCountryCode(wine.winery?.countryCode ?? ""),
          contextMenuViewModels: contextMenuViewModels)
      }

      sections += [.wines(.init(wines: winesContent, contentOffsetX: recommendedWinesContentOffsetX))]
    }

    if !data.assortimentWines.isEmpty {

      let winesContent: [HorizontalWineView.Content] = data.assortimentWines.map({ wine in
        let buttonText: String? = {
          if cartItems.contains(where: { $0.productID == wine.id }) {
            return "✔︎"
          }
          if let amount = wine.price?.amount, let currency = wine.price?.currencyCode {
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

        return HorizontalWineView.Content.init(
          wineID: wine.id,
          imageURL: wine.mainImageUrl?.toURL,
          titleText: wine.title,
          subtitleText: subtitleText,
          buttonText: buttonText,
          oldPriceText: nil,
          badgeText: nil,
          rating: wine.rating)
      })

      var assortmentsContent = [StoreViewModel.AssortimentContent]()

      assortmentsContent.append(.contentCoulBeNotRight(content: localized("wines_assortiment_could_be_not_right").firstLetterUppercased()))

      winesContent.enumerated().forEach { index, wineContent in
        if index % 10 == 0 && index != 0 {
//          assortmentsContent.append(.ad(itemID: .ad))
        }
        assortmentsContent.append(.horizontalWine(wineContent))
      }

      if data.selectedFilters.isEmpty {
        sections += [.assortiment(header: [localized("all").firstLetterUppercased()], content: assortmentsContent)]
      } else {
        var header: [String] = data.selectedFilters.compactMap({
          if $0.0 == "country" {
            return countryNameFromLocaleCode(countryCode: $0.1)
          }
          if $0.0 == "min_price" || $0.0 == "max_price" {
            return nil
          }
          return localized($0.1.lowercased()).firstLetterUppercased()
        })

        var priceOption: String = ""
        if data.selectedFilters.first(where: { $0.0 == "min_price" })?.1 == data.selectedFilters.first(where: { $0.0 == "max_price" })?.1 {
          if let minPrice = data.selectedFilters.first(where: { $0.0 == "min_price" })?.1, let intValue = Int64(minPrice) {
            priceOption = formatCurrencyAmount(intValue, currency: "RUB")
          }
        } else {
          if let minPrice = data.selectedFilters.first(where: { $0.0 == "min_price" })?.1, let intValue = Int64(minPrice) {
            priceOption += localized("AdvancesdSearch.Price.From").firstLetterUppercased() + " " + formatCurrencyAmount(intValue, currency: "RUB")
          }
          if let maxPrice = data.selectedFilters.first(where: { $0.0 == "max_price" })?.1, let intValue = Int64(maxPrice) {
            priceOption += " " + localized("AdvancesdSearch.Price.To").firstLetterUppercased() + " " + formatCurrencyAmount(intValue, currency: "RUB")
          }
        }
        if !priceOption.isNilOrEmpty {
          header.insert(priceOption, at: 0)
        }

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

        var header: [String] = data.selectedFilters.compactMap({
          if $0.0 == "country" {
            return countryNameFromLocaleCode(countryCode: $0.1)
          }

          if $0.0 == "min_price" || $0.0 == "max_price" {
            return nil
          }

          return localized($0.1.lowercased()).firstLetterUppercased()
        })

        var priceOption: String = ""

        if data.selectedFilters.first(where: { $0.0 == "min_price" })?.1 == data.selectedFilters.first(where: { $0.0 == "max_price" })?.1 {
          if let minPrice = data.selectedFilters.first(where: { $0.0 == "min_price" })?.1, let intValue = Int64(minPrice) {
            priceOption = formatCurrencyAmount(intValue, currency: "RUB")
          }
        } else {
          if let minPrice = data.selectedFilters.first(where: { $0.0 == "min_price" })?.1, let intValue = Int64(minPrice) {
            priceOption += localized("AdvancesdSearch.Price.From").firstLetterUppercased() + " " + formatCurrencyAmount(intValue, currency: "RUB")
          }
          if let maxPrice = data.selectedFilters.first(where: { $0.0 == "max_price" })?.1, let intValue = Int64(maxPrice) {
            priceOption += " " + localized("AdvancesdSearch.Price.To").firstLetterUppercased() + " " + formatCurrencyAmount(intValue, currency: "RUB")
          }
        }

        if !priceOption.isNilOrEmpty {
          header.insert(priceOption, at: 0)
        }

        sections += [.assortiment(header: header, content: assortmentsContent)]
      }
    }

    let bottomPriceBarViewModel: BottomPriceBarView.Content? = {
      guard let totalPrice = totalPrice, totalPrice > 0 else {
        return nil
      }
      return .init(leadingText: "Оформить заказ", trailingButtonText: String(totalPrice), isLoading: isBottomButtonLoading)
    }()

    let viewModel = StoreViewModel(
      sections: sections,
      navigationTitleText: data.partnerInfo.title,
      shouldResetContentOffset: false,
      isLiked: data.isLiked,
      bottomPriceBarViewModel: bottomPriceBarViewModel)
    viewController?.updateUI(viewModel: viewModel)
  }
}
