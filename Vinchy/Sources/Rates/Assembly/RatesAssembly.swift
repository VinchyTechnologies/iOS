//
//  RatesAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class RatesAssembly {
  static func assemblyModule(input: RatesInput) -> RatesViewController {
    let viewController = RatesViewController()
    let router = RatesRouter(input: input, viewController: viewController)
    let presenter = RatesPresenter(viewController: viewController)
    let interactor = RatesInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
