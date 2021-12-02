//
//  RatesRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - RatesRouter

final class RatesRouter {

  // MARK: Lifecycle

  init(
    input: RatesInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: RatesInteractorProtocol?

  // MARK: Private

  private let input: RatesInput
}

// MARK: RatesRouterProtocol

extension RatesRouter: RatesRouterProtocol {}
