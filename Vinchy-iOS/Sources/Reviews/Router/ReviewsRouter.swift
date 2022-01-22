//
//  ReviewsRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - ReviewsRouter

final class ReviewsRouter {

  // MARK: Lifecycle

  init(
    input: ReviewsInput,
    viewController: UIViewController,
    coordinator: ReviewDetailRoutable)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ReviewsInteractorProtocol?
  let coordinator: ReviewDetailRoutable

  // MARK: Private

  private let input: ReviewsInput
}

// MARK: ReviewsRouterProtocol

extension ReviewsRouter: ReviewsRouterProtocol {

  func showBottomSheetReviewDetailViewController(reviewInput: ReviewDetailInput) {
    coordinator.showBottomSheetReviewDetailViewController(reviewInput: reviewInput)
  }
}
