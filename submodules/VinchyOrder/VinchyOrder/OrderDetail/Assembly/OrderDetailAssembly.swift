//
//  OrderDetailAssembly.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import UIKit.UIViewController

final class OrderDetailAssembly {
  public static func assemblyModule(input: OrderDetailInput) -> UIViewController {
    let viewController = OrderDetailViewController()
    let router = OrderDetailRouter(input: input, viewController: viewController)
    let presenter = OrderDetailPresenter(viewController: viewController)
    let interactor = OrderDetailInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
