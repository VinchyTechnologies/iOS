//
//  WineDetailAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

public final class WineDetailAssembly {

  public typealias Coordinator = WineDetailRoutable & ReviewsRoutable & ReviewDetailRoutable & WriteReviewRoutable & ActivityRoutable & WriteNoteRoutable & StoresRoutable & StoreRoutable & AuthorizationRoutable

  public static func assemblyModule(input: WineDetailInput, coordinator: Coordinator) -> UIViewController {
    let viewController = WineDetailViewController(input: input)
    let router = WineDetailRouter(input: input, viewController: viewController, coordinator: coordinator)
    let presenter = WineDetailPresenter(input: input, viewController: viewController)
    let interactor = WineDetailInteractor(input: input, router: router, presenter: presenter)
    router.interactor = interactor
    viewController.interactor = interactor
    return viewController
  }
}
