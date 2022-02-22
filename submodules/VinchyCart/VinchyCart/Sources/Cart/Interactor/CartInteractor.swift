//
//  CartInteractor.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Core
import VinchyCore

// MARK: - CartItem

class CartItem: Decodable {

  // MARK: Lifecycle

  init(productID: Int64, type: Kind, count: Int) {
    self.productID = productID
    self.type = type
    self.count = count
  }

  // MARK: Internal

  enum Kind: Decodable {
    case wine
  }

  let productID: Int64
  let type: Kind
  var count: Int
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

  private var cartItems: [CartItem] = [.init(productID: 1, type: .wine, count: 12)]

  private let input: CartInput
  private let router: CartRouterProtocol
  private let presenter: CartPresenterProtocol
  private let throttler = Throttler()
}

// MARK: CartInteractorProtocol

extension CartInteractor: CartInteractorProtocol {

  func didTapTrashButton() {
    cartItems.removeAll()
    router.dismiss()
  }

  func getCountOfProduct(productID: Int64, type: CartItem.Kind) -> Int {
    if let cartItem = cartItems.first(where: { $0.productID == productID && $0.type == type }) {
      return cartItem.count
    }
    return 0
  }

  func didTapStepper(productID: Int64, type: CartItem.Kind, value: Int) {
    // make request
    throttler.cancel()
    throttler.throttle(delay: .seconds(1)) { [weak self] in
      if let product = self?.cartItems.first(where: { $0.productID == productID }) {
        product.count = value
      }
    }
  }

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
