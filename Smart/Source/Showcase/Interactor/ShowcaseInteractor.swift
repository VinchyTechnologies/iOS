//
//  ShowcaseInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - C

private enum C {
  static let limit: Int = 40
}

// MARK: - ShowcaseInteractor

final class ShowcaseInteractor {

  // MARK: Lifecycle

  init(
    input: ShowcaseInput,
    router: ShowcaseRouterProtocol,
    presenter: ShowcasePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private let input: ShowcaseInput
  private let router: ShowcaseRouterProtocol
  private let presenter: ShowcasePresenterProtocol
  private let stateMachine = PagingStateMachine<[ShortWine]>()
  private var wines: [ShortWine] = []
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func loadData(offset: Int) {
    switch input.mode {
    case .normal(let data):
      stateMachine.invokeSuccess(with: data)

    case .advancedSearch(var params):
      if offset == .zero {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dispatchWorkItemHud.perform()
        }
      }

      params += [("offset", String(offset)), ("limit", String(C.limit))]
      Wines.shared.getFilteredWines(params: params) { [weak self] result in
        guard let self = self else { return }

        if offset == .zero {
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }
        }

        switch result {
        case .success(let data):
          self.stateMachine.invokeSuccess(with: data)

        case .failure(let error):
          self.stateMachine.fail(with: error)
        }
      }

    case .partner(let partnerID, let affilatedID):
      if offset == .zero {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dispatchWorkItemHud.perform()
        }
      }
      Partners.shared.getPartnerWines(
        partnerId: partnerID,
        affilatedId: affilatedID,
        limit: C.limit,
        offset: offset) { [weak self] result in
          guard let self = self else { return }

          if offset == .zero {
            self.dispatchWorkItemHud.cancel()
            DispatchQueue.main.async {
              self.presenter.stopLoading()
            }
          }

          switch result {
          case .success(let data):
            self.stateMachine.invokeSuccess(with: data)

          case .failure(let error):
            self.stateMachine.fail(with: error)
          }
      }
    }
  }

  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    stateMachine.load(offset: wines.count)
  }

  private func handleLoadedData(_ data: [ShortWine], oldState: PagingState<[ShortWine]>) {
    wines += data
    var needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset):
      needLoadMore = wines.count == offset + C.limit
    }

    if case ShowcaseMode.normal = input.mode {
      needLoadMore = false
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(wines: wines, needLoadMore: needLoadMore)
      if wines.isEmpty {
        presenter.showInitiallyLoadingError(error: error)
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      if wines.isEmpty {
        presenter.showNothingFoundErrorView()
      } else {
        presenter.update(wines: wines, needLoadMore: needLoadMore)
      }
    }
  }
}

// MARK: ShowcaseInteractorProtocol

extension ShowcaseInteractor: ShowcaseInteractorProtocol {
  func willDisplayLoadingView() {
    loadMoreData()
  }

  func viewDidLoad() {
    loadInitData()
  }

  func didSelectWine(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}
