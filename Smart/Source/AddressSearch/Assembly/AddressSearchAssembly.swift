//
//  AddressSearchAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display

final class AddressSearchAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = AddressSearchViewController()
    let router = AddressSearchRouter(input: .init(), viewController: viewController)
    let presenter = AddressSearchPresenter(viewController: viewController)
    let interactor = AddressSearchInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return NavigationController(rootViewController: viewController)
  }
}
