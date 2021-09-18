//
//  VinchyRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Display
import FittedSheets
import StringFormatting
import UIKit
import VinchyCore

// MARK: - VinchyRouter

final class VinchyRouter {

  // MARK: Lifecycle

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: VinchyInteractorProtocol?
}

// MARK: VinchyRouterProtocol

extension VinchyRouter: VinchyRouterProtocol {

  func presentAreYouInStoreBottomSheet(nearestPartner: NearestPartner) {
    let options = SheetOptions(shrinkPresentingViewController: false)
    let controller = AreYouInStoreAssembly.assemblyModule(input: .init(partner: nearestPartner))

    let bottomButtonsViewModel = BottomButtonsViewModel(
      leadingButtonText: localized("AreYouInStore.NotHere"),
      trailingButtonText: localized("AreYouInStore.SeeMore"))

    let recommendedWines = nearestPartner.recommendedWines.compactMap({ CollectionItem.wine(wine: $0) })

    let viewModel = AreYouInStoreViewModel(
      sections: [
        .title([
          .init(titleText: NSAttributedString(string: localized("AreYouInStore.SeemsYouAreIn") + nearestPartner.partner.title.quoted, font: Font.bold(24), textColor: .dark, paragraphAlignment: .center)),
        ]),

        .title([
          .init(titleText: NSAttributedString(string: localized("AreYouInStore.RecommendToBuy"), font: Font.regular(16), textColor: .dark)),
        ]),

        .recommendedWines([
          .init(type: .bottles, collections: [.init(wineList: recommendedWines)]),
        ]),
      ],
      bottomButtonsViewModel: bottomButtonsViewModel)

    let height = AreYouInStoreViewController.height(viewModel: viewModel) // TODO: - input
    let sheetController = SheetViewController(controller: controller, sizes: [.fixed(height)], options: options)
    viewController?.present(sheetController, animated: true)
  }

  func pushToStoreViewController(affilatedId: Int) {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId)))
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller,
      animated: true)
  }

  func pushToAdvancedFilterViewController() {
    viewController?.navigationController?.pushViewController(
      Assembly.buildFiltersModule(), animated: true)
  }

  func pushToDetailCollection(searchText: String) {
    let input = ShowcaseInput(title: nil, mode: .advancedSearch(params: [("title", searchText)]))
    pushToShowcaseViewController(input: input)
  }
}
