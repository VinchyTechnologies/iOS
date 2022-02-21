//
//  OrderDetailRouter.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import UIKit

// MARK: - OrderDetailRouter

final class OrderDetailRouter {

  // MARK: Lifecycle

  init(
    input: OrderDetailInput,
    viewController: UIViewController)
  {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: UIViewController?
  weak var interactor: OrderDetailInteractorProtocol?

  // MARK: Private

  private let input: OrderDetailInput
}

// MARK: OrderDetailRouterProtocol

extension OrderDetailRouter: OrderDetailRouterProtocol {}
