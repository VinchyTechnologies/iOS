//
//  StoresInteractor.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import VinchyCore

// MARK: - C

fileprivate enum C {
  static let limit: Int = 40
}

// MARK: - StoresInteractorError

enum StoresInteractorError: Error {
  case initialLoading(APIError)
  case loadMore(APIError)
}

// MARK: - StoresInteractor

final class StoresInteractor {

  // MARK: Lifecycle

  init(
    input: StoresInput,
    router: StoresRouterProtocol,
    presenter: StoresPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private let router: StoresRouterProtocol
  private let presenter: StoresPresenterProtocol
  private let input: StoresInput
  private let stateMachine = PagingStateMachine<[PartnerInfo]>()
  private var partnersInfo: [PartnerInfo] = []

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset, _):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error as? StoresInteractorError, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func handleLoadedData(_ data: [PartnerInfo], oldState: PagingState<[PartnerInfo]>) {
    var needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset, _):
      needLoadMore = partnersInfo.count == offset + C.limit
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: StoresInteractorError? = nil, needLoadMore: Bool) {
    dispatchWorkItemHud.cancel()
    DispatchQueue.main.async {
      self.presenter.stopLoading()
    }

    if let error = error {
      switch error {
      case .initialLoading(let error):
        presenter.showInitiallyLoadingError(error: error)

      case .loadMore(let error):
        presenter.showErrorAlert(error: error)
      }

    } else {
      presenter.update(partnersInfo: partnersInfo, needLoadMore: needLoadMore)
    }
  }

  private func loadData(offset: Int) {
    Partners.shared.getPartnersByWine(
      wineID: input.wineID,
      latitude: 55.755786,
      longitude: 37.617633,
      limit: C.limit,
      offset: offset) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          self.partnersInfo += response
          self.stateMachine.invokeSuccess(with: self.partnersInfo)

        case .failure(let error):
          self.stateMachine.fail(with: error)
        }
    }
  }

  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    stateMachine.load(offset: partnersInfo.count)
  }
}

// MARK: StoresInteractorProtocol

extension StoresInteractor: StoresInteractorProtocol {

  func didSelectPartner(affiliatedStoreId: Int) {
    router.presentStore(affilatedId: affiliatedStoreId)
  }

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func didTapReloadButton() {
    dispatchWorkItemHud.perform()
    loadInitData()
  }

  func viewDidLoad() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
    loadInitData()
  }
}
