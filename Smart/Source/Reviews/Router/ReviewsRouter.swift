//
//  ReviewsRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - ReviewsRouter

final class ReviewsRouter {

  // MARK: Lifecycle

  init(
    input: ReviewsInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ReviewsInteractorProtocol?

  // MARK: Private

  private let input: ReviewsInput
}

// MARK: ReviewsRouterProtocol

extension ReviewsRouter: ReviewsRouterProtocol {}
