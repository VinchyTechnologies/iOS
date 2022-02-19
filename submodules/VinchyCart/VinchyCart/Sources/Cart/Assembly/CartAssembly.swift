//
//  CartAssembly.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import UIKit

public final class CartAssembly {

  public static func assemblyModule(input: CartInput) -> UIViewController {
    let viewController = CartViewController()
    let router = CartRouter(input: input, viewController: viewController)
    let presenter = CartPresenter(viewController: viewController)
    let interactor = CartInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
