//
//  ResultsSearchAssembly.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ResultsSearchAssembly {

  static func assemblyModule() -> ResultsSearchViewController {
    let viewController = ResultsSearchViewController()

    let router = ResultsSearchRouter(viewController: viewController)
    let presenter = ResultsSearchPresenter(viewController: viewController)
    let interactor = ResultsSearchInteractor(router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
