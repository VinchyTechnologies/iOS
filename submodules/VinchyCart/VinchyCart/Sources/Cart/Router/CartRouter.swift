//
//  CartRouter.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import UIKit

// MARK: - CartRouter

final class CartRouter {

  // MARK: Lifecycle

  init(
    input: CartInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: CartInteractorProtocol?

  // MARK: Private

  private let input: CartInput
}

// MARK: CartRouterProtocol

extension CartRouter: CartRouterProtocol {}
