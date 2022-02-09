//
//  VinchyRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AdvancedSearch
import Core
import DisplayMini
import FittedSheets
import StringFormatting
import UIKit
import VinchyCore
import VinchyStore
import VinchyUI

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

  func presentChangeAddressViewController() {
    let controller = AddressSearchAssembly.assemblyModule()
    ((controller as? VinchyNavigationController)?.viewControllers.first as? AddressSearchViewController)?.delegate = self
    viewController?.present(controller, animated: true, completion: nil)
  }

  func presentAreYouInStoreBottomSheet(nearestPartner: NearestPartner) {
    let options = SheetOptions(shrinkPresentingViewController: false)
    let controller = AreYouInStoreAssembly.assemblyModule(input: .init(partner: nearestPartner))

    let bottomButtonsViewModel = BottomButtonsViewModel(
      leadingButtonText: localized("AreYouInStore.NotHere"),
      trailingButtonText: localized("AreYouInStore.SeeMore"))

    let recommendedWines = nearestPartner.recommendedWines

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
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId), isAppClip: false), coordinator: Coordinator.shared, adFabricProtocol: AdFabric.shared)
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller,
      animated: true)
  }

  func pushToAdvancedFilterViewController() {
    let controller = FiltersAssembly.assemblyModule(input: .init(preselectedFilters: [], isPriceFilterAvailable: false))
    controller.hidesBottomBarWhenPushed = true
    viewController?.navigationController?.pushViewController(
      controller, animated: true)
  }

  func pushToDetailCollection(searchText: String) {
    let input = ShowcaseInput(title: nil, mode: .advancedSearch(params: [("title", searchText)]))
    pushToShowcaseViewController(input: input)
  }
}

// MARK: AddressSearchViewControllerDelegate

extension VinchyRouter: AddressSearchViewControllerDelegate {
  func didChooseAddress() {
    interactor?.didChangeAddress()
  }
}
