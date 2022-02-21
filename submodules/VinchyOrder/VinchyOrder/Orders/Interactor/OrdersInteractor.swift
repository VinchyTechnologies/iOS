//
//  OrdersInteractor.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import Core
import VinchyCore

// MARK: - C

fileprivate enum C {
  static let limit: Int = 40
}

// MARK: - OrdersInteractor

final class OrdersInteractor {

  // MARK: Lifecycle

  init(
    router: OrdersRouterProtocol,
    presenter: OrdersPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
    configureStateMachine()
  }

  // MARK: Private

  private let router: OrdersRouterProtocol
  private let presenter: OrdersPresenterProtocol
  private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
    guard let self = self else { return }
    self.presenter.startLoading()
  }
  private var orders: [Order] = []
  private let stateMachine = PagingStateMachine<[Order]>()

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
    if offset == .zero {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dispatchWorkItemHud.perform()
      }
    }

    if offset == .zero {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dispatchWorkItemHud.perform()
      }
    }
    Collections.shared.getDetailCollection(collectionID: 5, completion: { [weak self] result in
      guard let self = self else { return }

      if offset == .zero {
        self.dispatchWorkItemHud.cancel()
        DispatchQueue.main.async {
          self.presenter.stopLoading()
        }
      }

      switch result {
      case .success(let data):
        let data: [Order] = [.init(id: 1)]
        self.stateMachine.invokeSuccess(with: data) // TODO: -

      case .failure(let error):
        self.stateMachine.fail(with: error)
      }
    })
  }

  private func loadInitData() {
    stateMachine.load(offset: .zero)
  }

  private func loadMoreData() {
    stateMachine.load(offset: orders.count)
  }

  private func handleLoadedData(_ data: [Order], oldState: PagingState<[Order]>) {
    orders += data
    var needLoadMore: Bool
    switch oldState {
    case .error, .loaded, .initial:
      needLoadMore = false

    case .loading(let offset, _):
      needLoadMore = orders.count == offset + C.limit
    }

    showData(needLoadMore: needLoadMore)
  }

  private func showData(error: Error? = nil, needLoadMore: Bool) {
    if let error = error {
      presenter.update(orders: orders, needLoadMore: needLoadMore)
      if orders.isEmpty {
        presenter.showInitiallyLoadingError(error: error)
      } else {
        presenter.showErrorAlert(error: error)
      }
    } else {
      if orders.isEmpty {
        presenter.showNothingFoundErrorView()
      } else {
        presenter.update(orders: orders, needLoadMore: needLoadMore)
      }
    }
  }
}

// MARK: OrdersInteractorProtocol

extension OrdersInteractor: OrdersInteractorProtocol {

  func willDisplayLoadingView() {
    loadMoreData()
  }

  func viewDidLoad() {
    loadInitData()
  }

  func didSelectOrder(orderID: Int) {
    router.pushToOrderDetailViewController(orderID: orderID)
  }
}
