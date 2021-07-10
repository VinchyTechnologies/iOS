//
//  SearchInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - C

private enum C {
  static let searchSuggestionsCount = 20
}

// MARK: - SearchInteractor

final class SearchInteractor {

  // MARK: Lifecycle

  init(
    router: SearchRouterProtocol,
    presenter: SearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: SearchRouterProtocol
  private let presenter: SearchPresenterProtocol
  private let dispatchGroup = DispatchGroup()

  private var suggestions: [Wine] = []

  private func fetchSearchSuggestions() {
    dispatchGroup.enter()
    var suggestions: [Wine] = []

    Wines.shared.getRandomWines(count: C.searchSuggestionsCount) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let model):
        suggestions = model

      case .failure:
        break
      }
      self.dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      self.suggestions = suggestions

      self.presenter.update(suggestions: suggestions)
    }
  }
}

// MARK: SearchInteractorProtocol

extension SearchInteractor: SearchInteractorProtocol {

  func viewDidLoad() {
    fetchSearchSuggestions()
  }
}
