//
//  WriteReviewRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class WriteReviewRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: WriteReviewInteractorProtocol?
  private let input: WriteReviewInput
  
  init(
    input: WriteReviewInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - WriteReviewRouterProtocol

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
