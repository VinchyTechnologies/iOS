//
//  AdvancedSearchRouter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class AdvancedSearchRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: AdvancedSearchInteractorProtocol?
  private let input: AdvancedSearchInput
  
  init(
    input: AdvancedSearchInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - AdvancedSearchRouterProtocol

extension AdvancedSearchRouter: AdvancedSearchRouterProtocol {
  
}
