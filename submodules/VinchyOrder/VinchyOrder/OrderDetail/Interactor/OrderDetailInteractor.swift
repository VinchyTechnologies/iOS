//
//  OrderDetailInteractor.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import Foundation

// MARK: - OrderDetailInteractor

final class OrderDetailInteractor {

  // MARK: Lifecycle

  init(
    router: OrderDetailRouterProtocol,
    presenter: OrderDetailPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: OrderDetailRouterProtocol
  private let presenter: OrderDetailPresenterProtocol
}

// MARK: OrderDetailInteractorProtocol

extension OrderDetailInteractor: OrderDetailInteractorProtocol {
  func viewDidLoad() {
    presenter.update()
  }
}
