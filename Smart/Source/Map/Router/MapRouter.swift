//
//  MapRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import FittedSheets
import UIKit
import VinchyStore

// MARK: - MapRouter

final class MapRouter {

  // MARK: Lifecycle

  init(
    input: MapInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: MapInteractorProtocol?

  private(set) var sheetMapDetailStoreViewController: SheetViewController?

  // MARK: Private

  private let input: MapInput
}

// MARK: MapRouterProtocol

extension MapRouter: MapRouterProtocol {
  func showMapDetailStore(partnerId: Int, affilatedId: Int) {
    let options = SheetOptions(shrinkPresentingViewController: false)
    let mapDetailStore = MapDetailStoreAssembly.assemblyModule(input: .init(partnerId: partnerId, affilatedId: affilatedId))
    mapDetailStore.delegate = viewController as? MapViewController
    let sheetController = SheetViewController(
      controller: mapDetailStore,
      sizes: [.fixed(150)],
      options: options)
    sheetMapDetailStoreViewController = sheetController
    sheetController.didDismiss = { _ in
      self.interactor?.requestBottomSheetDismissToDeselectSelectedPin()
    }

    if let tabbarController = UIApplication.topViewController()?.tabBarController {
      tabbarController.present(sheetController, animated: true, completion: nil)
    }
  }

  func dismissCurrentBottomSheet(shouldUseDidDismissCallback: Bool) {
    if !shouldUseDidDismissCallback {
      sheetMapDetailStoreViewController?.didDismiss = nil
    }
    sheetMapDetailStoreViewController?.attemptDismiss(animated: true)
  }

  func showAssortmentViewController(partnerId: Int, affilatedId: Int, title: String?) {
    let controller = StoreAssembly.assemblyModule(input: .init(mode: .normal(affilatedId: affilatedId)), coordinator: Coordinator.shared, adFabricProtocol: AdFabric.shared)
    let navigationController = VinchyNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overCurrentContext
    UIApplication.topViewController()?.present(navigationController, animated: true, completion: nil)
  }
}
