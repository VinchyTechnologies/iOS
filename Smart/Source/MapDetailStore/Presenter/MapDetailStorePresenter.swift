//
//  MapDetailStorePresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import StringFormatting
import VinchyCore

// MARK: - MapDetailStorePresenter

final class MapDetailStorePresenter {

  // MARK: Lifecycle

  init(viewController: MapDetailStoreViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: MapDetailStoreViewControllerProtocol?
}

// MARK: MapDetailStorePresenterProtocol

extension MapDetailStorePresenter: MapDetailStorePresenterProtocol {

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func update(storeInfo: PartnerInfo, recommendedWines: [ShortWine]) {
    var rows: [MapDetailStoreViewModel.Row] = []

//    sections += [.navigationBar([.init()])]

    rows += [.title(.init(titleText: NSAttributedString(string: storeInfo.title, font: Font.bold(24), textColor: .dark, paragraphAlignment: .center)))]

    if let address = storeInfo.address {
      rows += [.address(.init(titleText: NSAttributedString(string: address, font: Font.regular(18), textColor: .dark, paragraphAlignment: .center)))]
    }

//    rows += [.workingHours(.init(titleText: "19:00 - 20:00"))]

    rows += [.assortment(.init(titleText: localized("view_assortment").firstLetterUppercased()))]

    if !recommendedWines.isEmpty {
      rows += [
        .title(.init(
          titleText: NSAttributedString(
            string: localized("vinchy_recommends").firstLetterUppercased(),
            font: Font.heavy(20),
            textColor: .dark))),
      ]

      rows += [
        .recommendedWines(
          .init(
            type: .bottles,
            collections: [
              .init(wineList: recommendedWines),
            ])),
      ]
    }

    viewController?.updateUI(viewModel: .init(sections: [.content(header: .init(), items: rows)]))
  }

  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }
}
