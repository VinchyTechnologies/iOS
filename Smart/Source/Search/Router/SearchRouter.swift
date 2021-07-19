//
//  SearchRouter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit
import VinchyCore

// MARK: - SearchRouter

final class SearchRouter {

  // MARK: Lifecycle

  init(
    input: SearchInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: SearchInteractorProtocol?

  // MARK: Private

  private let input: SearchInput

}

// MARK: SearchRouterProtocol

extension SearchRouter: SearchRouterProtocol {
  func pushToDetailCollection(searchText: String) {
    let input = ShowcaseInput(title: nil, mode: .advancedSearch(params: [("title", searchText)]))
    pushToShowcaseViewController(input: input)
  }
}
