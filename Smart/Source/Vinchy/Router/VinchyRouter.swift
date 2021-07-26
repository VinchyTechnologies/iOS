//
//  VinchyRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit
import VinchyCore

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
  func pushToAdvancedFilterViewController() {
    viewController?.navigationController?.pushViewController(
      Assembly.buildFiltersModule(), animated: true)
  }

  func pushToDetailCollection(searchText: String) {
    let input = ShowcaseInput(title: nil, mode: .advancedSearch(params: [("title", searchText)]))
    pushToShowcaseViewController(input: input)
  }
}
