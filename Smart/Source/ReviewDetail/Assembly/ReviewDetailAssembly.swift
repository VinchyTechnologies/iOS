//
//  ReviewDetailAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

final class ReviewDetailAssembly {

  static func assemblyModule(input: ReviewDetailInput) -> ReviewDetailViewController {
    let viewController = ReviewDetailViewController()
    let router = ReviewDetailRouter(input: input, viewController: viewController)
    let presenter = ReviewDetailPresenter(input: input, viewController: viewController)
    let interactor = ReviewDetailInteractor(router: router, presenter: presenter)
    
    router.interactor = interactor
    viewController.interactor = interactor
    
    return viewController
  }
}
