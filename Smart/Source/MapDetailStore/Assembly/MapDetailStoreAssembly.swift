//
//  MapDetailStoreAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

final class MapDetailStoreAssembly {
  static func assemblyModule(input: MapDetailStoreInput) -> MapDetailStoreViewController {

    let viewController = MapDetailStoreViewController()

    let router = MapDetailStoreRouter(input: input, viewController: viewController)
    let presenter = MapDetailStorePresenter(viewController: viewController)
    let interactor = MapDetailStoreInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor
    return viewController
  }
}
