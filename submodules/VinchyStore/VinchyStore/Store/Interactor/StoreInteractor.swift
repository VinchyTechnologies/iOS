//
//  StoreInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import CoreLocation
import Database
import Spotlight
import UIKit
import VinchyCore
import VinchyUI
import Widget

// MARK: - StoreInteractorData

struct StoreInteractorData {
  let partnerInfo: PartnerInfo
  var recommendedWines: [ShortWine] = []
  var assortimentWines: [ShortWine] = []
  var selectedFilters: [(String, String)] = []
  var isLiked: Bool
}

// MARK: - StoreInteractorError

enum StoreInteractorError: Error {
  case initialLoading(APIError)
  case loadMore(APIError)
}

// MARK: - C

fileprivate enum C {
  static let limit: Int = 40
}

// MARK: - StoreInteractor

final class StoreInteractor {

  // MARK: Lifecycle

  init(
    input: StoreInput,
    router: StoreRouterProtocol,
    presenter: StorePresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private let dispatchGroup = DispatchGroup()

  private let dataBase = storesRepository

  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }

  private var presenter: StorePresenterProtocol
  private let authService = AuthService.shared

  private let input: StoreInput
  private let router: StoreRouterProtocol
  private let stateMachine = PagingStateMachine<StoreInteractorData>()
  private var data: StoreInteractorData?
  private var partnerInfo: PartnerInfo?
  private var assortimentWines: [ShortWine] = []
  private var personalRecommendedWines: [ShortWine]?
  private var selectedFilters: [(String, String)] = []

  private func configureStateMachine() {
    stateMachine.observe { [weak self] oldState, newState, _ in
      guard let self = self else { return }
      switch newState {
      case .loaded(let data):
        self.handleLoadedData(data, oldState: oldState)

      case .loading(let offset, _):
        self.loadData(offset: offset)

      case .error(let error):
        self.showData(error: error as? StoreInteractorError, needLoadMore: false)

      case .initial:
        break
      }
    }
  }

  private func loadData(offset: Int) {
    var generalError: StoreInteractorError?
    switch input.mode {
    case .normal(let affilatedId):
      if partnerInfo == nil {
        dispatchGroup.enter()
        Partners.shared.getPartnerStoreInfo(partnerId: 1, affilatedId: affilatedId) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
            self.partnerInfo = response
            SpotlightService.shared.addStore(affilatedId: affilatedId, title: response.title, subtitle: response.address)

          case .failure(let error):
            generalError = .initialLoading(error)
            print(error.localizedDescription)
          }
          self.dispatchGroup.leave()
        }
      }

      if personalRecommendedWines == nil {
        dispatchGroup.enter()
        Recommendations.shared.getPersonalRecommendedWines(
          accountId: authService.currentUser?.accountID ?? 0,
          affilatedId: affilatedId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
              self.personalRecommendedWines = response

            case .failure(let error):
              print(error)
              if self.data == nil {
                self.personalRecommendedWines = nil
              } else {
                self.personalRecommendedWines = []
              }
            }
            self.dispatchGroup.leave()
        }
      }

      dispatchGroup.enter()
      Partners.shared.getPartnerWines(
        partnerId: 1,
        affilatedId: affilatedId,
        filters: selectedFilters,
        limit: C.limit,
        offset: offset) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
            self.assortimentWines += response

          case .failure(let error):
            if self.assortimentWines.isEmpty {
              generalError = .initialLoading(error)
            } else {
              generalError = .loadMore(error)
            }
          }
          self.dispatchGroup.leave()
      }

      dispatchGroup.notify(queue: .main) {
        if let partnerInfo = self.partnerInfo {
          let data = StoreInteractorData(
            partnerInfo: partnerInfo,
            recommendedWines: self.personalRecommendedWines ?? [],
            assortimentWines: self.assortimentWines,
            selectedFilters: self.selectedFilters,
            isLiked: self.isLiked(affilatedId: self.partnerInfo?.affiliatedStoreId))
          self.data = data
          self.stateMachine.invokeSuccess(with: data)
        } else {
          if let error = generalError {
            self.stateMachine.fail(with: error)
          }
        }
      }

    case .hasPersonalRecommendations:
      break
    }
  }

  private func isLiked(affilatedId: Int?) -> Bool {
    guard let affilatedId = affilatedId else {
      return false
    }
    return dataBase.findAll().first(where: { $0.affilatedId == affilatedId }) != nil
  }

  private func loadInitData() {
    assortimentWines = []
    data?.assortimentWines = []
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    guard let data = data else { return }
    stateMachine.load(offset: data.assortimentWines.count)
  }

  private func handleLoadedData(_ data: StoreInteractorData, oldState: PagingState<StoreInteractorData>) {
    var needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset, _):
      needLoadMore = (self.data?.assortimentWines.count ?? 0) == offset + C.limit
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: StoreInteractorError? = nil, needLoadMore: Bool) {
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
}

// MARK: StoreInteractorProtocol

extension StoreInteractor: StoreInteractorProtocol {

  var contextMenuRouter: ActivityRoutable & WriteNoteRoutable {
    router
  }

  func didTapSubscribe() {
    print(#function)
  }

  func didTapMore(button: UIButton) {
    presenter.showMoreOptions(sourceView: button)
  }
  func didTapShare(sourceView: UIView) {
    guard let partnerInfo = partnerInfo else {
      return
    }
    router.didTapShareStore(type: .fullInfo(affilatedId: partnerInfo.affiliatedStoreId, titleText: partnerInfo.title, logoURL: partnerInfo.logoURL?.toURL, sourceView: sourceView))
  }

  func didTapLikeButton() {
    guard let partnerInfo = partnerInfo else {
      return
    }
    if let dbStore = dataBase.findAll().first(where: { $0.affilatedId == partnerInfo.affiliatedStoreId }) {
      dataBase.remove(dbStore)
      var stores = WidgetStorage.shared.getWidgetStores()
      if stores.contains(where: { $0.id == partnerInfo.affiliatedStoreId }) {
        stores.removeAll(where: { $0.id == partnerInfo.affiliatedStoreId })
        WidgetStorage.shared.save(stores: stores)
      }
      presenter.setLikedStatus(isLiked: false)
    } else {
      let maxId = dataBase.findAll().map { $0.id }.max() ?? 0
      let id = maxId + 1
      dataBase.append(VStore(id: id, affilatedId: partnerInfo.affiliatedStoreId, title: partnerInfo.title, subtitle: partnerInfo.address, logoURL: partnerInfo.logoURL))
      presenter.setLikedStatus(isLiked: true)
//      presenter.showStatusAlertDidLikedSuccessfully()
    }
  }
  func didTapHorizontalWineViewButton(wineID: Int64) {
    if let wineURL = assortimentWines.first(where: { $0.id == wineID })?.url?.toURL {
      router.presentSafari(url: wineURL)
    }
  }

  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.router.didTapShare(
          type: .fullInfo(
            wineID: wineID,
            titleText: response.title,
            bottleURL: response.mainImageUrl?.toURL,
            sourceView: sourceView))

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }

  func didTapWriteNoteContextMenu(wineID: Int64) {
    Wines.shared.getDetailWine(wineID: wineID) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        let contextMenuWine = response
        if let note = notesRepository.findAll().first(where: { $0.wineID == wineID }) {
          self.contextMenuRouter.presentWriteViewController(note: note)
        } else {
          self.contextMenuRouter.presentWriteViewController(wine: contextMenuWine)
        }

      case .failure(let errorResponse):
        print(errorResponse)
      }
    }
  }

  func didTapSearchButton() {
    switch input.mode {
    case .normal(let affilatedId):
      router.pushToResultsSearchController(affilatedId: affilatedId, resultsSearchDelegate: self)

    case .hasPersonalRecommendations(let affilatedId, _):
      router.pushToResultsSearchController(affilatedId: affilatedId, resultsSearchDelegate: self)
    }
  }

  func didTapMapButton(button: UIButton) {
    if let lat = partnerInfo?.latitude, let lon = partnerInfo?.longitude {
      router.showRoutesActionSheet(
        storeTitleText: partnerInfo?.title,
        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
        button: button)
    }
  }

  func didChoose(_ filters: [(String, String)]) {
    guard let partnerInfo = partnerInfo else {
      return
    }
    presenter.setLoadingFilters(data: .init(partnerInfo: partnerInfo, recommendedWines: personalRecommendedWines ?? [], assortimentWines: [], isLiked: isLiked(affilatedId: partnerInfo.affiliatedStoreId)))
    selectedFilters = filters
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
      self.loadInitData()
    }
  }

  func didTapFilterButton() {
    router.presentFilter(preselectedFilters: selectedFilters)
  }

  func didTapReloadButton() {
    dispatchWorkItemHud.perform()
    loadInitData()
  }

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func viewDidLoad() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.dispatchWorkItemHud.perform()
    }
    loadInitData()
  }

  func didSelectWine(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }
}

// MARK: ResultsSearchDelegate

extension StoreInteractor: ResultsSearchDelegate {
  func didTapBottleCell(wineID: Int64) {
    router.pushToWineDetailViewController(wineID: wineID)
  }

  func didTapSearchButton(searchText: String?) { }
}
