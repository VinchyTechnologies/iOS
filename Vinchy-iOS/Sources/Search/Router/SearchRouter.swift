//
//  SearchRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit
import VinchyCore

// MARK: - SearchRouter

final class SearchRouter {

  // MARK: Lifecycle

  init(
    viewController: UIViewController)
  {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: SearchInteractorProtocol?
  var emailService = EmailService()

}

// MARK: SearchRouterProtocol

extension SearchRouter: SearchRouterProtocol {
}
