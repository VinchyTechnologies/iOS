//
//  MapRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 02.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

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
  
}
