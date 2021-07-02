//
//  SearchPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - SearchPresenter

final class SearchPresenter {

  // MARK: Lifecycle

  init(viewController: SearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: SearchViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = SearchViewModel

}

// MARK: SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {

}
