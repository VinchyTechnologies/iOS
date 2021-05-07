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
    guard let controller = viewController else {
      return
    }
    
    let options = SheetOptions(shrinkPresentingViewController: false)
    
    let mapDetailStore = MapDetailStoreAssembly.assemblyModule(input: .init(partnerId: partnerId, affilatedId: affilatedId))
    let sheet = SheetViewController(
      controller: mapDetailStore,
      sizes: [.percent(0.75), .fullscreen],
      options: options)
    
    controller.present(sheet, animated: true, completion: nil)
  }
}
