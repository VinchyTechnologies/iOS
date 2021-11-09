//
//  SavedAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class SavedAssembly {
  static func assemblyModule(input: SavedInput) -> UIViewController {
    let viewController = SavedViewController()

    let router = SavedRouter(input: input, viewController: viewController)
    let presenter = SavedPresenter(viewController: viewController)
    let interactor = SavedInteractor(router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
