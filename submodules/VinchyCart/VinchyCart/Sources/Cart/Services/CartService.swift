//
//  CartService.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 31.03.2022.
//

import Combine
import Database
import UIKit

// MARK: - CartModel

struct CartModel {

  // MARK: Lifecycle

  init(items: [CartItem]) {
    if !cartRepository.isEmpty() {
      cartRepository.removeAll()
    }

    DispatchQueue.global(qos: .utility).async {
      let models: [VCartItem] = items.enumerated().compactMap { index, cartItem in
        .init(id: index, affilatedId: nil, productId: cartItem.productID, kind: .wine, quantity: cartItem.count)
      }
      cartRepository.append(models)
    }
    self.items = items
  }

  //    var wholeSum: Double {
  //        return items.reduce(0) { partialResult, cartModel in
  //            return partialResult + cartModel.product.price * Double(cartModel.count)
  //        }
  //    }
  //
  //    var wholeProductCount: Int {
  //        return items.map { $0.count }.reduce(0, +)
  //    }

  // MARK: Internal

  let items: [CartItem]
}

// MARK: - CartService

final class CartService {

  // MARK: Lifecycle

  private init() {
//    cancellable = $cartModel.sink(receiveValue: { [weak self] model in
    //          let count = model.wholeProductCount
    //          self?.cartTabBarItem?.badgeValue = count > 0 ? String(count) : nil
//    })
  }

  // MARK: Internal

  static let shared = CartService()

  @Published var cartModel = CartModel(items: [])

  func removeProduct(_ product: CartItem) {
    guard let index = cartModel.items.firstIndex(where: { $0.productID == product.productID }) else {
      return
    }
    var oldItems = cartModel.items
    oldItems.remove(at: index)
    cartModel = CartModel(items: oldItems)
  }

  func addProduct(_ product: CartItem) {
    if let alreadyExistCartItemIndex = cartModel.items.firstIndex(where: { $0.productID == product.productID }) {
      var oldItems = cartModel.items
      oldItems[alreadyExistCartItemIndex] = CartItem(
        productID: oldItems[alreadyExistCartItemIndex].productID,
        type: oldItems[alreadyExistCartItemIndex].type,
        count: oldItems[alreadyExistCartItemIndex].count + 1)
      cartModel = .init(items: oldItems)
      return
    }

    let newCartItem = CartItem(productID: product.productID, type: product.type, count: 1)
    let oldItems = cartModel.items
    cartModel = .init(items: oldItems + [newCartItem])
  }

  func removeAll() {
    cartModel = .init(items: [])
  }

  // MARK: Private

  private var cancellable: Cancellable?
}
