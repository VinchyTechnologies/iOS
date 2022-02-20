//
//  OrdersAssembly.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import UIKit

public final class OrdersAssembly {
  public static func assemblyModule(input: OrdersInput) -> UIViewController {
    let viewController = OrdersViewController()
    let router = OrdersRouter(input: input, viewController: viewController)
    let presenter = OrdersPresenter(viewController: viewController)
    let interactor = OrdersInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
