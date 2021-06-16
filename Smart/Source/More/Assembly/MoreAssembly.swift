//
//  MoreAssembly.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit

final class MoreAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = MoreViewController()
    let router = MoreRouter(viewController: viewController)
    let presenter = MorePresenter(viewController: viewController)
    let interactor = MoreInteractor(presenter: presenter, router: router)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
