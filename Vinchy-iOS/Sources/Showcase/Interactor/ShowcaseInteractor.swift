//
//  ShowcaseInteractor.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import UIKit.UIView
import VinchyCore
import VinchyUI

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
  private lazy var title: String? = input.title
  private var logoURL: URL?
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

      case .loading(let offset, _):
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
    case .questions(let optionsIds, let affilatedId): // TODO: - request
      if offset == .zero {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dispatchWorkItemHud.perform()
        }
      }

      let params: [(String, String)] = [("color", "red")]
      Partners.shared.getPartnerWines(partnerId: 1, affilatedId: affilatedId, filters: params, currencyCode: "RUB", limit: 40, offset: offset, completion: { [weak self] result in
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
      })

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

    case .remote(let collectionID):
      if offset == .zero {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dispatchWorkItemHud.perform()
        }
      }
      Collections.shared.getDetailCollection(collectionID: collectionID, completion: { [weak self] result in
        guard let self = self else { return }

        if offset == .zero {
          self.dispatchWorkItemHud.cancel()
          DispatchQueue.main.async {
            self.presenter.stopLoading()
          }
        }

        switch result {
        case .success(let data):
          self.title = data.title
          self.logoURL = data.imageURL?.toURL
          self.stateMachine.invokeSuccess(with: data.wineList)

        case .failure(let error):
          self.stateMachine.fail(with: error)
        }
      })
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

    case .loading(let offset, _):
      needLoadMore = wines.count == offset + C.limit
    }

    switch input.mode {
    case .remote:
      needLoadMore = false

    case .advancedSearch, .questions:
      break
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(title: title, wines: wines, needLoadMore: needLoadMore)
      if wines.isEmpty {
        presenter.showInitiallyLoadingError(error: error)
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      if wines.isEmpty {
        presenter.showNothingFoundErrorView()
      } else {
        presenter.update(title: title, wines: wines, needLoadMore: needLoadMore)
      }
    }
  }
}

// MARK: ShowcaseInteractorProtocol

extension ShowcaseInteractor: ShowcaseInteractorProtocol {
  func didTapPriceButton(wineID: Int64) {
    switch input.mode {
    case .advancedSearch, .remote:
      break

    case .questions(_, let affilatedId):
      router.presentQRViewController(affilatedId: affilatedId, wineID: wineID)
    }
  }

  func didTapRepeatQuestionsButton() {
    router.popToRootQuestions()
  }

  func didTapShare(sourceView: UIView) {
    switch input.mode {
    case .remote(let collectionID):
      router.didTapShareCollection(type: .fullInfo(collectionID: collectionID, titleText: title, logoURL: logoURL, sourceView: sourceView))

    case .advancedSearch, .questions:
      return
    }
  }

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func viewDidLoad() {
    loadInitData()
  }

  func didSelectWine(wineID: Int64) {
    switch input.mode {
    case .advancedSearch, .remote:
      router.pushToWineDetailViewController(wineID: wineID, mode: .normal, shouldShowSimilarWine: true)

    case .questions(_, let affilatedId):
      guard let wine = wines.first(where: { $0.id == wineID }), let price = wine.price else {
        return
      }
      router.pushToWineDetailViewController(wineID: wineID, mode: .partner(affilatedId: affilatedId, price: price, buyAction: .qr(affilietedId: affilatedId)), shouldShowSimilarWine: true)
    }
  }
}
