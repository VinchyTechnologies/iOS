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

// MARK: - StoresInteractorData

struct StoresInteractorData {
  let partnersInfo: [PartnerInfo]
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
  private let stateMachine = PagingStateMachine<StoresInteractorData>()
  private let dispatchGroup = DispatchGroup()
  private var partnersInfo: [PartnerInfo]?
  private var data: StoresInteractorData?

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error as? StoresInteractorError, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func handleLoadedData(_ data: StoresInteractorData, oldState: PagingState<StoresInteractorData>) {
    var needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset):
      needLoadMore = (self.data?.partnersInfo.count ?? 0) == offset + C.limit
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
      guard let data = data else {
        return
      }
      presenter.update(data: data, needLoadMore: needLoadMore)
    }
  }

  private func loadData(offset: Int) {
    var generalError: StoresInteractorError?
    if partnersInfo == nil {
      dispatchGroup.enter()
      Partners.shared.getPartnersByWine(wineID: input.wineID, latitude: 55.755786, longitude: 37.617633, limit: C.limit, offset: offset) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          self.partnersInfo = response
        case .failure(let error):
          generalError = .initialLoading(error)
          print(error.localizedDescription)
        }
        self.dispatchGroup.leave()
      }
    }

    dispatchGroup.notify(queue: .main) {
      if let partnersInfo = self.partnersInfo {
        let data = StoresInteractorData(partnersInfo: partnersInfo)
        self.data = data
        self.stateMachine.invokeSuccess(with: data)
      } else {
        if let error = generalError {
          self.stateMachine.fail(with: error)
        }
      }
    }
  }
  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    guard let data = data else { return }
    stateMachine.load(offset: data.partnersInfo.count)
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
