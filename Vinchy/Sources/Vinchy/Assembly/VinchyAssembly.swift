//
//  VinchyAssembly.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import LocationUI
import VinchyCore

final class VinchyAssembly {
  static func assemblyModule() -> VinchyViewController {
    let viewController = VinchyViewController()

    let router = VinchyRouter(viewController: viewController)
    let presenter = VinchyPresenter(viewController: viewController)
    let repository = VinchyRepository(locationService: LocationService(), authService: AuthService.shared)
    let interactor = VinchyInteractor(router: router, presenter: presenter, repository: repository)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
