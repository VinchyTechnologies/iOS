//
//  AdvancedSearchAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class AdvancedSearchAssembly {
  static func assemblyModule(input: AdvancedSearchInput) -> AdvancedSearchViewController {
    let viewController = AdvancedSearchViewController()

    let router = AdvancedSearchRouter(input: input, viewController: viewController)
    let presenter = AdvancedSearchPresenter(input: input, viewController: viewController)
    let interactor = AdvancedSearchInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
