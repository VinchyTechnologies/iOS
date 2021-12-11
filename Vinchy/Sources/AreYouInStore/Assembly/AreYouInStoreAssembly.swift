//
//  AreYouInStoreAssembly.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class AreYouInStoreAssembly {
  static func assemblyModule(input: AreYouInStoreInput) -> AreYouInStoreViewController {
    let viewController = AreYouInStoreViewController()
    let router = AreYouInStoreRouter(input: input, viewController: viewController)
    let presenter = AreYouInStorePresenter(input: input, viewController: viewController)
    let interactor = AreYouInStoreInteractor(input: input, router: router, presenter: presenter)

    router.interactor = interactor
    viewController.interactor = interactor

    return viewController
  }
}
