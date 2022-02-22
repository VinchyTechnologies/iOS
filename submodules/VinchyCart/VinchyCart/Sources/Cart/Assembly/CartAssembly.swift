//
//  CartAssembly.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import UIKit
import VinchyUI

public final class CartAssembly {

  public typealias Coordinator = WineDetailRoutable

  public static func assemblyModule(input: CartInput, coordinator: Coordinator) -> UIViewController {
    let viewController = CartViewController()
    let router = CartRouter(input: input, viewController: viewController, coordinator: coordinator)
    let presenter = CartPresenter(viewController: viewController)
    let interactor = CartInteractor(input: input, router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
