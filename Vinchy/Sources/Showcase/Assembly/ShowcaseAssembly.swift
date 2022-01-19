//
//  ShowcaseAssembly.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 3/11/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import VinchyUI

final class ShowcaseAssembly {
  static func assemblyModule(input: VinchyUI.ShowcaseInput) -> UIViewController {
    let viewController = ShowcaseViewController()
    let router = ShowcaseRouter(viewController: viewController, coordinator: Coordinator.shared)
    let presenter = ShowcasePresenter(input: input, viewController: viewController)
    let interactor = ShowcaseInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
