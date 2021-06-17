//
//  WriteReviewAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class WriteReviewAssembly {
  static func assemblyModule(input: WriteReviewInput) -> WriteReviewViewController {
    let viewController = WriteReviewViewController()
    let router = WriteReviewRouter(input: input, viewController: viewController)
    let presenter = WriteReviewPresenter(input: input, viewController: viewController)
    let interactor = WriteReviewInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
