//
//  CartInteractor.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import VinchyCore

// MARK: - CartItem

struct CartItem: Decodable {

  enum Kind: Decodable {
    case wine
  }

  let productId: Int
  let type: Kind
  let count: Int
}

// MARK: - CartInteractor

final class CartInteractor {

  // MARK: Lifecycle

  init(
    input: CartInput,
    router: CartRouterProtocol,
    presenter: CartPresenterProtocol)
  {
    self.input = input
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private var cartItems: [CartItem] = []

  private let input: CartInput
  private let router: CartRouterProtocol
  private let presenter: CartPresenterProtocol
}

// MARK: CartInteractorProtocol

extension CartInteractor: CartInteractorProtocol {

  func didTapConfirmOrderButton() {
    // create order if success else alert
    presenter.updateWithSuccess(orderId: 13)
  }

  func didSelectHorizontalWine(wineID: Int64) {
//    router.presentWineDetail(wineID: wineID, affilatedId: , price: )
  }

  func viewDidLoad() {
    presenter.update()
  }
}
