//
//  StoresRouter.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - StoresRouter

final class StoresRouter {

  // MARK: Lifecycle

  init(
    input: StoresInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: StoresInteractorProtocol?

  // MARK: Private

  private let input: StoresInput
}

// MARK: StoresRouterProtocol

extension StoresRouter: StoresRouterProtocol {}
