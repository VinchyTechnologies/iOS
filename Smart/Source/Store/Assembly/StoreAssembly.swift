//
//  StoreAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class StoreAssembly {
  static func assemblyModule(input: StoreInput) -> UIViewController {
    let viewController = StoreViewController()
    let router = StoreRouter(input: input, viewController: viewController)
    let presenter = StorePresenter(viewController: viewController)
    let interactor = StoreInteractor(input: input, router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
