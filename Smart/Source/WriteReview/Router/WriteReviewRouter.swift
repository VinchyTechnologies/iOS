//
//  WriteReviewRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - WriteReviewRouter

final class WriteReviewRouter {

  // MARK: Lifecycle

  init(
    input: WriteReviewInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: WriteReviewInteractorProtocol?

  // MARK: Private

  private let input: WriteReviewInput
}

// MARK: WriteReviewRouterProtocol

extension WriteReviewRouter: WriteReviewRouterProtocol {
  func dismissAfterUpdate(statusAlertViewModel: StatusAlertViewModel) {
    viewController?.dismiss(animated: true, completion: {
      let topViewController = UIApplication.topViewController() as? StatusAlertable
      topViewController?.showStatusAlert(viewModel: statusAlertViewModel)
    })
  }

  func dismissAfterCreate(statusAlertViewModel: StatusAlertViewModel) {
    viewController?.dismiss(animated: true, completion: {
      let topViewController = UIApplication.topViewController() as? StatusAlertable
      topViewController?.showStatusAlert(viewModel: statusAlertViewModel)
    })
  }
}
