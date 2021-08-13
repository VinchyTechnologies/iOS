//
//  AreYouInStoreRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - AreYouInStoreRouter

final class AreYouInStoreRouter {

  // MARK: Lifecycle

  init(
    input: AreYouInStoreInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: AreYouInStoreInteractorProtocol?

  // MARK: Private

  private let input: AreYouInStoreInput

}

// MARK: AreYouInStoreRouterProtocol

extension AreYouInStoreRouter: AreYouInStoreRouterProtocol {

}
