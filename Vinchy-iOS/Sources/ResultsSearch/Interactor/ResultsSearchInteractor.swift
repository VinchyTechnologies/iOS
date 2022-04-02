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
    input: ResultsSearchInput,
    router: ResultsSearchRouterProtocol,
    presenter: ResultsSearchPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let input: ResultsSearchInput
  private let router: ResultsSearchRouterProtocol
  private let presenter: ResultsSearchPresenterProtocol
  private let throttler = Throttler()

  private var recentlySearchedWines: [VSearchedWine] = []
  private var wines: [ShortWine] = []

  private func fetchSearchedWines() {
    recentlySearchedWines = searchedWinesRepository.findAll()
    presenter.update(searchedWines: recentlySearchedWines)
  }
}

// MARK: ResultsSearchInteractorProtocol

extension ResultsSearchInteractor: ResultsSearchInteractorProtocol {

  func didSelectHorizontalWine(wineID: Int64) {
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

    if let wine = wines.first(where: { $0.id == wineID }) {
      searchedWinesRepository.append(VSearchedWine(id: id, wineID: wineID, title: wine.title, createdAt: Date()))
    }
  }

  func didTapHistoryWine(wineID: Int64) {
    if let wine = searchedWinesRepository.findAll().first(where: { $0.wineID == wineID }) {
      searchedWinesRepository.remove(wine)
      let maxId = searchedWinesRepository.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      searchedWinesRepository.append(VSearchedWine(id: id, wineID: wineID, title: wine.title, createdAt: Date()))
    }
  }

  func viewWillAppear() {
    switch input.mode {
    case .normal:
      fetchSearchedWines()

    case .storeDetail:
      break
    }
  }

  func didEnterSearchText(_ searchText: String?) {
    guard
      let searchText = searchText,
      !searchText.isEmpty
    else {
      switch input.mode {
      case .normal:
        throttler.throttle(delay: .milliseconds(600)) { [weak self] in
          self?.fetchSearchedWines()
        }

      case .storeDetail:
        presenter.update(didFindWines: [])
      }

      return
    }
    throttler.cancel()

    throttler.throttle(delay: .milliseconds(600)) { [weak self] in
      guard let self = self else { return }
      switch self.input.mode {
      case .normal:
        Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { [weak self] result in
          switch result {
          case .success(let wines):
            self?.wines = wines
            self?.presenter.update(didFindWines: wines)

          case .failure:
            self?.wines = []
            self?.presenter.update(didFindWines: [])
          }
        }

      case .storeDetail(let affilatedId, let currencyCode):
        Partners.shared.getPartnerWines(partnerId: 1, affilatedId: affilatedId, filters: [("title", searchText)], currencyCode: currencyCode, limit: 10, offset: 0) { [weak self] result in
          switch result {
          case .success(let wines):
            self?.wines = wines
            self?.presenter.update(didFindWines: wines)

          case .failure:
            self?.wines = []
            self?.presenter.update(didFindWines: [])
          }
        }
      }
    }
  }
}
