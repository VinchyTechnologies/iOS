//
//  CartInteractor.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import Core
import Database
import VinchyCore

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

  private lazy var cartItems: [CartItem] = cartRepository.findAll().compactMap { item in
    if let productId = item.productId, let count = item.quantity {
      return .init(productID: productId, type: .wine, count: count)
    }
    return nil
  }

  private let input: CartInput
  private let router: CartRouterProtocol
  private let presenter: CartPresenterProtocol
  private let throttler = Throttler()
}

// MARK: CartInteractorProtocol

extension CartInteractor: CartInteractorProtocol {

  func didTapTrashButton() {
    cartItems.removeAll()
    cartRepository.removeAll()
    router.dismiss()
  }

  func getCountOfProduct(productID: Int64, type: CartItem.Kind) -> Int {
    if let cartItem = cartItems.first(where: { $0.productID == productID && $0.type == type }) {
      return cartItem.count
    }
    return 0
  }

  func didTapStepper(productID: Int64, type: CartItem.Kind, value: Int) {
    throttler.cancel()
    throttler.throttle(delay: .seconds(1)) { [weak self] in
      guard let self = self else { return }
      let cartItems = cartRepository.findAll()
      if
        let product = self.cartItems.first(where: { $0.productID == productID }),
        let cartItemToRemove = cartItems.first(where: { $0.productId == productID })
      {
        product.count = value
        cartRepository.remove(cartItemToRemove)
        if value > 0 {
          let cartItemToInsert: VCartItem = .init(id: cartItemToRemove.id, affilatedId: cartItemToRemove.affilatedId, productId: cartItemToRemove.productId, kind: cartItemToRemove.kind, quantity: value)
          cartRepository.insert(cartItemToInsert)
        }
      }

      // make request
      self.presenter.update()
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
    cartItems.forEach { Item in
      print(Item.productID, Item.count)
    }
    presenter.update()
  }
}
