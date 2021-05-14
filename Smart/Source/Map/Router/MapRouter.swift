//
//  MapRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import FittedSheets

final class MapRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: MapInteractorProtocol?
  private let input: MapInput
  
  private(set) var sheetMapDetailStoreViewController: SheetViewController?
  
  init(
    input: MapInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - MapRouterProtocol

extension MapRouter: MapRouterProtocol {
  func showMapDetailStore(partnerId: Int, affilatedId: Int) {
    let options = SheetOptions(shrinkPresentingViewController: false, useInlineMode: true)
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
      sheetController.animateIn(to: tabbarController.view, in: tabbarController)
    }
  }
  
  func dismissCurrentBottomSheet(shouldUseDidDismissCallback: Bool) {
    if !shouldUseDidDismissCallback {
      sheetMapDetailStoreViewController?.didDismiss = nil
    }
    sheetMapDetailStoreViewController?.attemptDismiss(animated: true)
  }
}
