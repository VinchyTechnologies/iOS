//
//  VinchyPresenter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - VinchyPresenter

final class VinchyPresenter {

  // MARK: Lifecycle

  init(viewController: VinchyViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: VinchyViewControllerProtocol?

  // MARK: Private

  private enum C {
    static let harmfulToYourHealthText = localized("harmful_to_your_health")
  }
}

// MARK: VinchyPresenterProtocol

extension VinchyPresenter: VinchyPresenterProtocol {

  func showAlertEmptyCollection() {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: localized("empty_collection"))
  }

  func stopPullRefreshing() {
    viewController?.stopPullRefreshing()
  }

  func startShimmer() {
    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .fake(sections: [
          .stories(itemID: .mini, content: .init(type: .stories(count: 10))),
          .title(itemID: .title, content: .init(type: .title(count: 1))),
          .promo(itemID: .mini, content: .init(type: .promo(count: 10))),
          .title(itemID: .title, content: .init(type: .title(count: 1))),
          .big(itemID: .mini, content: .init(type: .big(count: 10))),
          .title(itemID: .title, content: .init(type: .title(count: 1))),
          .promo(itemID: .mini, content: .init(type: .promo(count: 10))),
          .title(itemID: .title, content: .init(type: .title(count: 1))),
          .big(itemID: .mini, content: .init(type: .big(count: 10))),
        ]),
        leadingAddressButtonViewModel: .loading(text: localized("loading").firstLetterUppercased())))
  }

  func update(compilations: [Compilation], nearestPartners: [NearestPartner], city: String?, isLocationPermissionDenied: Bool) {

    var sections: [VinchyViewControllerViewModel.Section] = []

    if let storiesCompilation = compilations.first(where: {
      $0.type == .mini && ($0.title == nil || $0.title == "")
    }) {
      sections.append(.stories(content: storiesCompilation.collectionList.compactMap({ collection in
        .init(imageURL: collection.imageURL?.toURL, titleText: collection.title)
      })))
    }

    // TODO: - Nearest Stores

    nearestPartners.forEach { nearestPartner in
      sections.append(.storeTitle(content: .init(affilatedId: nearestPartner.partner.affiliatedStoreId, imageURL: nearestPartner.partner.logoURL, titleText: nearestPartner.partner.title, subtitleText: "", moreText: localized("more").firstLetterUppercased())))

      sections.append(.bottles(content: nearestPartner.recommendedWines.compactMap({
        .init(wineID: $0.id, imageURL: $0.mainImageUrl?.toURL, titleText: $0.title, subtitleText: countryNameFromLocaleCode(countryCode: $0.winery?.countryCode), rating: $0.rating, contextMenuViewModels: [])
      })))
    }

    for compilation in compilations {
      switch compilation.type {
      case .mini:
        if let title = compilation.title {
          sections.append(.title(title))
          sections.append(.stories(content: compilation.collectionList.compactMap({ collection in
            .init(imageURL: collection.imageURL?.toURL, titleText: collection.title)
          })))
        }

//      case .big:
//        if let title = compilation.title {
//          sections.append(.title([
//            .init(titleText: NSAttributedString(
//              string: title,
//              font: Font.heavy(20),
//              textColor: .dark)),
//          ]))
//        }
//        sections.append(.big([
//          .init(
//            type: compilation.type,
//            collections: compilation.collectionList),
//        ]))
//
//      case .promo:
//        if let title = compilation.title {
//          sections.append(.title([
//            .init(titleText: NSAttributedString(
//              string: title,
//              font: Font.heavy(20),
//              textColor: .dark)),
//          ]))
//        }
//        sections.append(.promo([
//          .init(
//            type: compilation.type,
//            collections: compilation.collectionList),
//        ]))

      case .bottles:
        if
          compilation.collectionList.first?.wineList != nil,
          let firstCollectionList = compilation.collectionList.first,
          !firstCollectionList.wineList.isEmpty {
          if let title = compilation.title {
            sections.append(.title(title))
          }

          sections.append(.bottles(content: firstCollectionList.wineList.compactMap({
            switch $0 {
            case .wine(let wine):
              return .init(wineID: wine.id, imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode), rating: wine.rating, contextMenuViewModels: [])

            case .ads: // TODO: - very legacy needs to delete
              return nil
            }
          })))
        }

      default:
        break

//      case .partnerBottles:
//        if
//          compilation.collectionList.first?.wineList != nil,
//          let firstCollectionList = compilation.collectionList.first, !firstCollectionList.wineList.isEmpty
//        {
//
//          if !didAddTitleAllStores {
//            sections.append(.title([.init(titleText: NSAttributedString(string: localized("nearest_stores"), font: Font.bold(22), textColor: .dark))]))
//            didAddTitleAllStores = true
//          }
//
        ////          if let title = compilation.title {
//          sections.append(.storeTitle([
//            .init(affilatedId: compilation.id, imageURL: compilation.imageURL, titleText: compilation.title, subtitleText: "400м • 5 мин. пешком", moreText: localized("more").firstLetterUppercased()),
//          ]))
        ////          }
//
//          sections.append(.bottles([
//            .init(
//              type: compilation.type,
//              collections: compilation.collectionList),
//          ]))
//        }

//      case .shareUs:
//        sections.append(.shareUs([
//          .init(titleText: localized("like_vinchy")),
//        ]))

//      case .smartFilter:
//        sections.append(.smartFilter([
//          .init(
//            accentText: "New in Vinchy".uppercased(),
//            boldText: "Personal compilations",
//            subtitleText: "Answer on 3 questions & we find for you best wines.",
//            buttonText: "Try now"),
//        ]))
      }
    }

//    sections.append(.title([
//      .init(titleText:
//        NSAttributedString(
//          string: C.harmfulToYourHealthText,
//          font: Font.light(15),
//          textColor: .blueGray,
//          paragraphAlignment: .justified)),
//    ]))

    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .normal(sections: sections),
        leadingAddressButtonViewModel: isLocationPermissionDenied ? .arraw(text: localized("enter_address").firstLetterUppercased()) : .arraw(text: city)))
  }
}
