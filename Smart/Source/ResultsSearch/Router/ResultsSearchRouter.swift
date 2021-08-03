//
//  ResultsSearchRouter.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit
import VinchyCore

// MARK: - ResultsSearchRouter

final class ResultsSearchRouter {

  // MARK: Lifecycle

  init(
    viewController: UIViewController)
  {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ResultsSearchInteractorProtocol?

}

// MARK: ResultsSearchRouterProtocol

extension ResultsSearchRouter: ResultsSearchRouterProtocol {}
