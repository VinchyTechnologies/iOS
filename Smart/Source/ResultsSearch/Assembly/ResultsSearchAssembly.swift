//
//  ResultsSearchAssembly.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyUI

final class ResultsSearchAssembly {

  static func assemblyModule(input: ResultsSearchInput, resultsSearchDelegate: ResultsSearchDelegate?) -> ResultsSearchViewController {
    let viewController = ResultsSearchViewController(input: input)
    viewController.resultsSearchDelegate = resultsSearchDelegate
    let router = ResultsSearchRouter(viewController: viewController)
    let presenter = ResultsSearchPresenter(viewController: viewController)
    let interactor = ResultsSearchInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
