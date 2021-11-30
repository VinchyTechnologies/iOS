//
//  SearchAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class SearchAssembly {

  static func assemblyModule(input: SearchInput) -> SearchViewController {
    let resultsController = ResultsSearchAssembly.assemblyModule(input: input.resultSearchInput)
    let viewController = SearchViewController(searchResultsController: resultsController)
    resultsController.didnotFindTheWineCollectionCellDelegate = viewController

    let router = SearchRouter(viewController: viewController)
    let presenter = SearchPresenter(viewController: viewController)
    let interactor = SearchInteractor(router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor
    return viewController
  }
}
