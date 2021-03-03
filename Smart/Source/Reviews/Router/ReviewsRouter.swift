//
//  ReviewsRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class ReviewsRouter {
  
  weak var viewController: UIViewController?
  weak var interactor: ReviewsInteractorProtocol?
  private let input: ReviewsInput
  
  init(
    input: ReviewsInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }
}

// MARK: - ReviewsRouterProtocol

extension ReviewsRouter: ReviewsRouterProtocol {
  
}
