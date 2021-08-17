//
//  StoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - StoreRouter

final class StoreRouter {

  // MARK: Lifecycle

  init(
    input: StoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: StoreInteractorProtocol?

  // MARK: Private

  private let input: StoreInput

}

// MARK: StoreRouterProtocol

extension StoreRouter: StoreRouterProtocol {

  func presentFilter(preselectedFilters: [(String, String)]) {
    let controller = AdvancedSearchAssembly.assemblyModule(
      input: .init(mode: .asView(preselectedFilters: preselectedFilters)))
    let navController = AdvancedSearchNavigationController(rootViewController: controller)
    navController.advancedSearchOutputDelegate = interactor
    viewController?.present(navController, animated: true, completion: nil)
  }
}
