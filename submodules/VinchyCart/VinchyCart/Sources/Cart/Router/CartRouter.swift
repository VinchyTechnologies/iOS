//
//  CartRouter.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import UIKit
import VinchyCore

// MARK: - CartRouter

final class CartRouter {

  // MARK: Lifecycle

  init(
    input: CartInput,
    viewController: UIViewController,
    coordinator: CartAssembly.Coordinator)
  {
    self.input = input
    self.viewController = viewController
    self.coordinator = coordinator
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: CartInteractorProtocol?

  // MARK: Private

  private let coordinator: CartAssembly.Coordinator

  private let input: CartInput
}

// MARK: CartRouterProtocol

extension CartRouter: CartRouterProtocol {

  func dismiss() {
    viewController?.dismiss(animated: true, completion: nil)
  }

  func presentWineDetail(wineID: Int64, affilatedId: Int, price: Price) {
    coordinator.presentWineDetailViewController(wineID: wineID, mode: .partner(affilatedId: affilatedId, price: price, buyAction: .cart(affilatedId: affilatedId, price: price)), shouldShowSimilarWine: false)
  }
}
