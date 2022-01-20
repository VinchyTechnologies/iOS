//
//  DebugSettingsAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 14.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class DebugSettingsAssembly {
  static func assemblyModule() -> UIViewController {
    let viewController = DebugSettingsViewController()
    let router = DebugSettingsRouter(coordinator: Coordinator.shared, viewController: viewController)
    let presenter = DebugSettingsPresenter(viewController: viewController)
    let interactor = DebugSettingsInteractor(router: router, presenter: presenter)

    viewController.interactor = interactor
    router.interactor = interactor

    return viewController
  }
}
