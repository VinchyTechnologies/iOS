//
//  ReviewDetailRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ReviewDetailRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: ReviewDetailInteractorProtocol?
  private let input: ReviewDetailInput
  
  init(
    input: ReviewDetailInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - ReviewDetailRouterProtocol

extension ReviewDetailRouter: ReviewDetailRouterProtocol {
  
}
