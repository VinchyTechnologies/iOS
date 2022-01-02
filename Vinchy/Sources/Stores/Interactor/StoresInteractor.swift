//
//  StoresInteractor.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import VinchyCore

// MARK: - C

fileprivate enum C {
  static let limit: Int = 40
}

// MARK: - StoresInteractorError

enum StoresInteractorError: Error {
  case initialLoading(APIError)
  case loadMore(APIError)
  case savedEmpty
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

  private let dataBase = storesRepository

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
      switch input.mode {
      case .wine:
        needLoadMore = partnersInfo.count == offset + C.limit

      case .saved:
        needLoadMore = false
      }
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

      case .savedEmpty:
        presenter.showNoSavedStores()
      }

    } else {
      presenter.update(partnersInfo: partnersInfo, needLoadMore: needLoadMore)
    }
  }

  private func loadData(offset: Int) {

    switch input.mode {
    case .wine(let wineID):
      Partners.shared.getPartnersByWine(
        wineID: wineID,
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
            if offset == 0 {
              self.stateMachine.fail(with: StoresInteractorError.initialLoading(error))
            } else {
              self.stateMachine.fail(with: StoresInteractorError.loadMore(error))
            }
          }
      }

    case .saved:
      partnersInfo = dataBase.findAll().compactMap { vstore in
        guard let affilatedId = vstore.affilatedId else {
          return nil
        }
        return PartnerInfo(affiliatedStoreId: affilatedId, title: vstore.title ?? "", latitude: nil, longitude: nil, affiliatedStoreType: nil, url: nil, phoneNumber: nil, scheduleOfWork: nil, address: vstore.subtitle, logoURL: vstore.logoURL)
      }

      if partnersInfo.isEmpty {
        stateMachine.fail(with: StoresInteractorError.savedEmpty)
      } else {
        stateMachine.invokeSuccess(with: partnersInfo)
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
    switch input.mode {
    case .wine:
      loadInitData()

    case .saved:
      break
    }
  }

  func viewWillAppear() {
    switch input.mode {
    case .wine:
      break

    case .saved:
      loadInitData()
    }
  }
}
