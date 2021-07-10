//
//  SearchPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import VinchyCore

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
  func update(suggestions: [Wine]) {
    var sections: [SearchViewModel.Section] = []

    suggestions.forEach { wine in
      sections.append(.recentlySearched([.init(wineID: wine.id, imageURL: nil, titleText: wine.title, subtitleText: wine.title)]))
      //sections.append(.suggestions([.init(titleText: wine.title)]))
    }

    viewController?.updateUI(viewModel: SearchViewModel(sections: sections))
  }
}
