//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - C

private enum C {
  static let searchSuggestionsCount = 20
}

// MARK: - VinchyInteractor

final class VinchyInteractor {

  // MARK: Lifecycle

  init(
    router: VinchyRouterProtocol,
    presenter: VinchyPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let dispatchGroup = DispatchGroup()
  private let emailService = EmailService()
  private let throttler = Throttler()

  private let router: VinchyRouterProtocol
  private let presenter: VinchyPresenterProtocol

  private var isSearchingMode = false
  private var suggestions: [Wine] = []
  private var compilations: [Compilation] = []

  private func fetchData() {
    dispatchGroup.enter()

    var compilations: [Compilation] = []

    Compilations.shared.getCompilations { [weak self] result in
      switch result {
      case .success(let model):
        compilations = model

      case .failure(let error):
        print(error.localizedDescription)
      }

      self?.dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }

      if isShareUsEnabled {
        let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
        compilations.insert(shareUs, at: compilations.isEmpty ? 0 : min(3, compilations.count - 1))
      }

      if isSmartFilterAvailable {
        let smartFilter = Compilation(type: .smartFilter, title: nil, collectionList: [])
        compilations.insert(smartFilter, at: 1)
      }

      self.compilations = compilations

      self.presenter.update(compilations: compilations)
    }
  }

  private func fetchSearchSuggestions() {
    Wines.shared.getRandomWines(count: C.searchSuggestionsCount) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let model):
        self.suggestions = model

      case .failure:
        break
      }
    }
  }
}

// MARK: VinchyInteractorProtocol

extension VinchyInteractor: VinchyInteractorProtocol {
  func didTapSuggestionCell(at indexPath: IndexPath) {
    if isSearchingMode {
      let wineID = suggestions[indexPath.section].id
      router.pushToWineDetailViewController(wineID: wineID)
    }
  }

  func searchBarTextDidBeginEditing() {
    isSearchingMode = true
    presenter.update(suggestions: suggestions)
  }

  func searchBarCancelButtonClicked() {
    isSearchingMode = false
    presenter.update(compilations: compilations)
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
      return
    }

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

  func viewDidLoad() {
    presenter.startShimmer()
    fetchData()
    fetchSearchSuggestions()
  }

  func didPullToRefresh() {
    if !isSearchingMode {
      fetchData()
      presenter.stopPullRefreshing()
    }
  }

  func didTapFilter() {
    router.pushToAdvancedFilterViewController()
  }

  func didTapDidnotFindWineFromSearch(searchText: String?) {
    guard let searchText = searchText else {
      return
    }

    if emailService.canSend {
      router.presentEmailController(
        HTMLText: presenter.cantFindWineText + searchText,
        recipients: presenter.cantFindWineRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }

  func didTapMapButton() {
    router.pushToMapViewController()
  }
}

// MARK: - VinchySimpleConiniousCaruselCollectionCellDelegate

extension VinchyInteractor {
  func didTapBottleCell(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }

  func didTapCompilationCell(wines: [ShortWine], title: String?) {
    guard !wines.isEmpty else {
      presenter.showAlertEmptyCollection()
      return
    }

    router.pushToShowcaseViewController(input: .init(title: title, mode: .normal(wines: wines)))
  }
}
