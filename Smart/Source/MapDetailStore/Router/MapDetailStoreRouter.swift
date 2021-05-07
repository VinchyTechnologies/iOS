//
//  MapDetailStoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class MapDetailStoreRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: MapDetailStoreInteractorProtocol?
  private let input: MapDetailStoreInput
  
  init(
    input: MapDetailStoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - MapDetailStoreRouterProtocol

extension MapDetailStoreRouter: MapDetailStoreRouterProtocol {
  
}
