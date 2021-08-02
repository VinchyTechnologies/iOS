//
//  ResultsSearchInteractor.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import VinchyCore

// MARK: - C

private enum C {
  static let searchedLimit: Int = 20
}

// MARK: - ResultsSearchInteractor

final class ResultsSearchInteractor {

  // MARK: Lifecycle

  init(
    router: ResultsSearchRouterProtocol,
    presenter: ResultsSearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Internal

  func fetchSearchedWines() {
    recentlySearchedWines = searchedWinesRepository.findAll()
    presenter.update(searched: recentlySearchedWines)
  }

  // MARK: Private

  private let router: ResultsSearchRouterProtocol
  private let presenter: ResultsSearchPresenterProtocol
  private let throttler = Throttler()

  private var recentlySearchedWines: [VSearchedWine] = []
}

// MARK: ResultsSearchInteractorProtocol

extension ResultsSearchInteractor: ResultsSearchInteractorProtocol {

  func viewWillAppear() {
    fetchSearchedWines()
  }

  func didSelectResultCell(wineID: Int64, title: String) {

    let count = searchedWinesRepository.findAll().count
    let maxId = searchedWinesRepository.findAll().map { $0.id }.max() ?? 0
    let id = maxId + 1

    if let sameWine = searchedWinesRepository.findAll().first(where: { $0.wineID == wineID }) {
      searchedWinesRepository.remove(sameWine)

    } else if count >= C.searchedLimit {
      if let firstWine = searchedWinesRepository.findAll().first {
        searchedWinesRepository.remove(firstWine)
      }
    }

    searchedWinesRepository.append(VSearchedWine(id: id, wineID: wineID, title: title))
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
      throttler.throttle(delay: .milliseconds(600)) { [weak self] in
        self?.fetchSearchedWines()
      }
      return
    }
    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { [weak self] result in
        switch result {
        case .success(let wines):
          self?.presenter.update(didFindWines: wines)

        case .failure(let error):
          self?.presenter.update(didFindWines: [])
          print(error.localizedDescription)
        }
      }
    }
  }

}
