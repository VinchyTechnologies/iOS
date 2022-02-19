//
//  CartInteractor.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Foundation

// MARK: - CartInteractor

final class CartInteractor {

  // MARK: Lifecycle

  init(
    router: CartRouterProtocol,
    presenter: CartPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: CartRouterProtocol
  private let presenter: CartPresenterProtocol
}

// MARK: CartInteractorProtocol

extension CartInteractor: CartInteractorProtocol {
  func viewDidLoad() {
    presenter.update()
  }
}
