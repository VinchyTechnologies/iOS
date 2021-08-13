//
//  MapDetailStoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import FittedSheets
import UIKit

// MARK: - MapDetailStoreRouter

final class MapDetailStoreRouter {

  // MARK: Lifecycle

  init(
    input: MapDetailStoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: MapDetailStoreInteractorProtocol?

  // MARK: Private

  private let input: MapDetailStoreInput
}

// MARK: MapDetailStoreRouterProtocol

extension MapDetailStoreRouter: MapDetailStoreRouterProtocol {
  func dismiss(completion: (() -> Void)?) {
    viewController?.sheetViewController?.attemptDismiss(animated: true)
    completion?()
  }
}
