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
          .stories(content: .init(type: .stories(count: 10))),
          .title(content: .init(type: .title(count: 1))),
          .promo(content: .init(type: .promo(count: 10))),
          .title(content: .init(type: .title(count: 1))),
          .big(content: .init(type: .big(count: 10))),
          .title(content: .init(type: .title(count: 1))),
          .promo(content: .init(type: .promo(count: 10))),
          .title(content: .init(type: .title(count: 1))),
          .big(content: .init(type: .big(count: 10))),
        ]),
        leadingAddressButtonViewModel: .loading(text: localized("loading").firstLetterUppercased())))
  }

  func update(compilations: [Compilation], nearestPartners: [NearestPartner], city: String?, isLocationPermissionDenied: Bool) {

    var sections: [VinchyViewControllerViewModel.Section] = []

    if
      let storiesCompilation = compilations.first(where: {
        $0.type == .mini && ($0.title == nil || $0.title == "")
      })
    {
      sections.append(.stories(content: storiesCompilation.collectionList.compactMap({ collection in
        .init(imageURL: collection.imageURL?.toURL, titleText: collection.title)
      })))
    }

    if !nearestPartners.isEmpty {
      sections.append(.nearestStoreTitle(content: localized("nearest_stores")))
    }

    nearestPartners.forEach { nearestPartner in
      sections.append(.storeTitle(content: .init(affilatedId: nearestPartner.partner.affiliatedStoreId, imageURL: nearestPartner.partner.logoURL, titleText: nearestPartner.partner.title, subtitleText: "", moreText: localized("more").firstLetterUppercased())))

      sections.append(.bottles(content: nearestPartner.recommendedWines.compactMap({
        .init(wineID: $0.id, imageURL: $0.mainImageUrl?.toURL, titleText: $0.title, subtitleText: countryNameFromLocaleCode(countryCode: $0.winery?.countryCode), rating: $0.rating, contextMenuViewModels: [])
      })))
    }

    for (index, compilation) in compilations.enumerated() {

      if index == 3 {
        sections.append(.shareUs(
          content: .init(titleText: localized("like_vinchy"))))
      }

      switch compilation.type {
      case .mini:
        if let title = compilation.title {
          sections.append(.title(content: title))
          sections.append(.stories(content: compilation.collectionList.compactMap({ collection in
            .init(imageURL: collection.imageURL?.toURL, titleText: collection.title)
          })))
        }

      case .big:
        if let title = compilation.title {
          sections.append(.title(content: title))
        }
        sections.append(.commonSubtitle(content: compilation.collectionList.compactMap({
          .init(subtitleText: $0.title, imageURL: $0.imageURL?.toURL)
        }), style: .init(kind: .big)))

      case .promo:
        if let title = compilation.title {
          sections.append(.title(content: title))
        }
        sections.append(.commonSubtitle(content: compilation.collectionList.compactMap({
          .init(subtitleText: $0.title, imageURL: $0.imageURL?.toURL)
        }), style: .init(kind: .promo)))

      case .bottles:
        if
          compilation.collectionList.first?.wineList != nil,
          let firstCollectionList = compilation.collectionList.first,
          !firstCollectionList.wineList.isEmpty
        {
          if let title = compilation.title {
            sections.append(.title(content: title))
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
      }
    }

    sections.append(.harmfullToYourHealthTitle(content: C.harmfulToYourHealthText))

    // TODO: - if all empty

    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .normal(sections: sections),
        leadingAddressButtonViewModel: isLocationPermissionDenied ? .arraw(text: localized("enter_address").firstLetterUppercased()) : .arraw(text: city)))
  }
}
