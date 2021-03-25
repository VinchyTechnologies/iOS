//
//  ReviewsAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ReviewsAssembly {
  static func assemblyModule(input: ReviewsInput) -> ReviewsViewController {
    let viewController = ReviewsViewController()
    let router = ReviewsRouter(input: input, viewController: viewController)
    let presenter = ReviewsPresenter(viewController: viewController)
    let interactor = ReviewsInteractor(input: input, router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
    
    return viewController
  }
}
