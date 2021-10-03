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
          .stories(.init(type: .stories(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .promo(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
          .title(.init(type: .title(count: 1))),
          .promo(.init(type: .big(count: 10))),
        ]),
        leadingAddressButtonViewModel: .loading(text: localized("loading").firstLetterUppercased())))
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func update(compilations: [Compilation], nearestPartners: [NearestPartner], city: String?, isLocationPermissionDenied: Bool) {
    viewController?.stopLoadingAnimation()

    var compilations = compilations

    nearestPartners.reversed().forEach { nearestPartner in
      let winesList = nearestPartner.recommendedWines.compactMap({ CollectionItem.wine(wine: $0) })
      let compilation = Compilation(id: nearestPartner.partner.affiliatedStoreId, type: .partnerBottles, imageURL: nearestPartner.partner.logoURL, title: nearestPartner.partner.title, collectionList: [Collection(wineList: winesList)])
      compilations.insert(compilation, at: 1)
    }

    var sections: [VinchyViewControllerViewModel.Section] = []

    for compilation in compilations {
      switch compilation.type {
      case .mini:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.stories([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .big:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.big([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .promo:
        if let title = compilation.title {
          sections.append(.title([
            .init(titleText: NSAttributedString(
              string: title,
              font: Font.heavy(20),
              textColor: .dark)),
          ]))
        }
        sections.append(.promo([
          .init(
            type: compilation.type,
            collections: compilation.collectionList),
        ]))

      case .bottles:
        if
          compilation.collectionList.first?.wineList != nil,
          let firstCollectionList = compilation.collectionList.first, !firstCollectionList.wineList.isEmpty
        {
          if let title = compilation.title {
            sections.append(.title([
              .init(titleText: NSAttributedString(
                string: title,
                font: Font.heavy(20),
                textColor: .dark)),
            ]))
          }

          sections.append(.bottles([
            .init(
              type: compilation.type,
              collections: compilation.collectionList),
          ]))
        }

      case .partnerBottles:
        if
          compilation.collectionList.first?.wineList != nil,
          let firstCollectionList = compilation.collectionList.first, !firstCollectionList.wineList.isEmpty
        {
//          if let title = compilation.title {
          sections.append(.storeTitle([
            .init(affilatedId: compilation.id, imageURL: compilation.imageURL, titleText: compilation.title, moreText: localized("more").firstLetterUppercased()),
          ]))
//          }

          sections.append(.bottles([
            .init(
              type: compilation.type,
              collections: compilation.collectionList),
          ]))
        }

      case .shareUs:
        sections.append(.shareUs([
          .init(titleText: localized("like_vinchy")),
        ]))

      case .smartFilter:
        sections.append(.smartFilter([
          .init(
            accentText: "New in Vinchy".uppercased(),
            boldText: "Personal compilations",
            subtitleText: "Answer on 3 questions & we find for you best wines.",
            buttonText: "Try now"),
        ]))
      }
    }

    sections.append(.title([
      .init(titleText:
        NSAttributedString(
          string: C.harmfulToYourHealthText,
          font: Font.light(15),
          textColor: .blueGray,
          paragraphAlignment: .justified)),
    ]))

    viewController?.updateUI(
      viewModel: VinchyViewControllerViewModel(
        state: .normal(sections: sections),
        leadingAddressButtonViewModel: isLocationPermissionDenied ? .arraw(text: localized("enter_address").firstLetterUppercased()) : .arraw(text: city)))
  }
}
