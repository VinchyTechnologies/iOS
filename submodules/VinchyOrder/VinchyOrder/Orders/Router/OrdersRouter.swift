//
//  OrdersRouter.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import UIKit

// MARK: - OrdersRouter

final class OrdersRouter {

  // MARK: Lifecycle

  init(
    input: OrdersInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: OrdersInteractorProtocol?

  // MARK: Private

  private let input: OrdersInput
}

// MARK: OrdersRouterProtocol

extension OrdersRouter: OrdersRouterProtocol {}
