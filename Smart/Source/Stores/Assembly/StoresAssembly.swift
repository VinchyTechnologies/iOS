//
//  StoresAssembly.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class StoresAssembly {
  static func assemblyModule(input: StoresInput) -> UIViewController {
    let viewController = StoresViewController()
    let router = StoresRouter(input: input, viewController: viewController)
    let presenter = StoresPresenter(viewController: viewController)
    let interactor = StoresInteractor(input: input, router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
