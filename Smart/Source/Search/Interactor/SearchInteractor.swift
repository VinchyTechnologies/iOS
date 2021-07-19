//
//  SearchInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import VinchyCore

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

  // MARK: Internal

  func fetchSearchedWines() {
    searched = searchedWinesRepository.findAll()
  }

  // MARK: Private

  private let throttler = Throttler()

  private let router: SearchRouterProtocol
  private let presenter: SearchPresenterProtocol
  private let dispatchGroup = DispatchGroup()

  private var searched: [VSearchedWine] = [] {
    didSet {
      presenter.update(searched: searched)
    }
  }
}

// MARK: SearchInteractorProtocol

extension SearchInteractor: SearchInteractorProtocol {

  func viewWillAppear() {
    fetchSearchedWines()
  }

  func didTapSearchButton(searchText: String?) {
    guard let searchText = searchText else {
      return
    }
    router.pushToDetailCollection(searchText: searchText)
  }

  func didEnterSearchText(_ searchText: String?) {
    guard
      let searchText = searchText,
      !searchText.isEmpty
    else {
      presenter.update(didFindWines: [])
      fetchSearchedWines()
      return
    }
    print(searchText)

    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { [weak self] result in
        switch result {
        case .success(let wines):
          self?.presenter.update(didFindWines: wines)

        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}
