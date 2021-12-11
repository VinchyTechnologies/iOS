//
//  ReviewDetailRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

// MARK: - ReviewDetailRouter

final class ReviewDetailRouter {

  // MARK: Lifecycle

  init(
    input: ReviewDetailInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: ReviewDetailInteractorProtocol?

  // MARK: Private

  private let input: ReviewDetailInput
}

// MARK: ReviewDetailRouterProtocol

extension ReviewDetailRouter: ReviewDetailRouterProtocol {}
